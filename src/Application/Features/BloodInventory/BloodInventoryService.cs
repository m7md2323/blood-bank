using Domain.Entities;
using Domain.Interfaces;
using Domain.Specifications;
using Domain.Enums;
using Domain.Specifications.BloodUnits;

namespace Application.Features.BloodInventory;

public class BloodInventoryService : IBloodInventoryService {

    private readonly IUnitOfWork _unitOfWork;

    public BloodInventoryService(IUnitOfWork unitOfWork){
        _unitOfWork = unitOfWork;
    }
    /*
        public BloodType BloodType {set;get;}    
        public ComponentType ComponentType {set;get;}
        public double VolumeMl {set;get;} = 0.0;
        public DateTime CollectionDate {set;get;}
        public DateTime ExpirationDate {set;get;}
        // Units remain quarantined until screening is approved.
        public BloodUnitStatus Status {set;get;} = BloodUnitStatus.Quarantined;

        //EF Core linking

        //Every Blood unit must be linked to a donor
        public Guid DonorId { get; set; }
        public User Donor { get; set; } = null!; 

        //In the case if a user is an Acceptor, the blood unit must be linked to him.
        public Guid? RecipientAcceptorId { get; set; }
        public User? RecipientAcceptor { get; set; }

        //Blood units can be in a blood bank or inside a hospital
        //We are treating the blood units that are inside a hospital as 
        //if they where placed in the ICU or any place closer to the doctor or patitint.
        //And we are treating blood units that are inside a blood bank,
        //as if they are placed in bank itself, whether its a section in the hospital, or a complete seperated blood bank center.
        public Guid? CurrentHospitalId { get; set; }
        public Hospital? CurrentHospital { get; set; }

        public Guid? CurrentBloodBankId { get; set; }
        public BloodBank? CurrentBloodBank { get; set; }

        public ICollection<BloodTestResult> TestResults { get; set; } = new List<BloodTestResult>();
    */

    // This method will add units to the Blood Bnank Inventory by a staff member.
    public async Task<bool> AddUnitAsync(Guid staffId, AddBloodUnitDto bloodUnitDto, CancellationToken ct){
        var staff = await _unitOfWork.Users.GetByIdAsync(staffId);


        if (staff is null || staff.CanManageInventory() == false || !staff.BloodBankId.HasValue){
            return false;
        }

        _ = Enum.TryParse<BloodType>(bloodUnitDto.BloodType, out var parseBloodType);
        _ = Enum.TryParse<ComponentType>(bloodUnitDto.ComponentType, out var parseComponantType);
        var newBloodUnit = BloodUnit.Create(
            bloodUnitDto.DonorId,
            staff.BloodBankId.Value,
            parseBloodType,
            parseComponantType,
            bloodUnitDto.VolumeMl,
            bloodUnitDto.CollectionDate,
            bloodUnitDto.ExpirationDate
        );
        
        await _unitOfWork.BloodUnits.AddAsync(newBloodUnit,ct);

        await _unitOfWork.SaveChangesAsync();

        return true;
    }
    // This method is responsable of giving a staff member a Summary of the Inventory.
    public async Task<InventorySummaryDto> GetInventorySummaryAsync(Guid staffId,CancellationToken ct){
        var staff = await _unitOfWork.Users.GetByIdAsync(staffId);

        if (staff is null || staff.CanManageInventory() == false || !staff.BloodBankId.HasValue){
            return null;
        }

        var bloodBank = staff.BloodBank;

        if(bloodBank is null)
            return null;

        if (bloodBank.StoredUnits.Count == 0)
            return null;
        
        ISpecification<BloodUnit> spec = new BloodUnitsByBloodBankSpec(bloodBank.Id);

        var bloodBankStoredUnit = await _unitOfWork.BloodUnits.ListAsync(spec,ct);

        var map = new Dictionary<(BloodType BloodType, ComponentType Component), (int Available,int Quarantined, int Expired)>();

        IReadOnlyList<BloodInventoryRecordDto> bloodInventoryRecords = [];

        foreach(BloodUnit Unit in bloodBankStoredUnit){

            var key = (Unit.BloodType,Unit.ComponentType);
            
            map.TryGetValue(key,out var counts);

            if (Unit.Status == BloodUnitStatus.Available && !Unit.IsExpired()){
                counts.Available++;
            }
            else if (Unit.Status == BloodUnitStatus.Quarantined && !Unit.IsExpired()){
                counts.Quarantined++;
            }
            else if (Unit.Status == BloodUnitStatus.Expired && !Unit.IsExpired()){
                counts.Expired++;
            }

            map[key] = counts;

        }

        bloodInventoryRecords = map.Select(kvp => new BloodInventoryRecordDto(
            kvp.Key.BloodType.ToString(),
            kvp.Key.Component.ToString(),
            kvp.Value.Available,
            kvp.Value.Quarantined,
            kvp.Value.Expired
            )
        
        ).ToList();         
    
        var inventorySummary = new InventorySummaryDto(
            bloodBank.Id,
            bloodBank.Name,
            bloodBank.StoredUnits.Count,
            bloodBank.CountBasedOnStatus(BloodUnitStatus.Available),
            bloodBank.CountBasedOnStatus(BloodUnitStatus.Quarantined),
            bloodBank.CountBasedOnStatus(BloodUnitStatus.Expired),
            bloodInventoryRecords
        );

        return inventorySummary;

    }
    public async Task<string> RecordTestResultAsync(Guid staffId, RecordBloodTestDto bloodTestDto,CancellationToken ct){
        var staff = await _unitOfWork.Users.GetByIdAsync(staffId);

        if (staff is null || staff.CanManageInventory() == false){
            return "Unauthorized.";
        }

        ISpecification<BloodUnit> spec = new BloodUnitWithTestsByIdSpec(bloodTestDto.BloodUnitId);
        var bloodUnit = await _unitOfWork.BloodUnits.GetBySpecAsync(spec,ct);

        if (bloodUnit is null){
            return "Blood Unit is not found or there is an error fetching it.";
        }

        if (bloodUnit.Status != BloodUnitStatus.Quarantined){
            return $"Cannot record test, unit status is {bloodUnit.Status}.";
        }

        if (!Enum.TryParse<TestType>(bloodTestDto.TestType, true, out var parseBloodTest))
        {
            return "Invalid test type provided.";
        }

        if (bloodUnit.TestResults.Any(t => t.TestType == parseBloodTest))
        {
            return $"Test {parseBloodTest} has already been recorded for this blood unit.";
        }

        var testResult = new BloodTestResult();
        
        if (bloodTestDto.IsPassed == true) {
            testResult = new BloodTestResult {
                BloodUnitId = bloodUnit.Id,
                TestType = parseBloodTest,
                TestResult = TestResult.Negative
            };

            bloodUnit.TestResults.Add(testResult);

            // Check if all tests are passed.
            var bloodUnitTests = bloodUnit.TestResults;
            if (bloodUnitTests.Count != Enum.GetNames<TestType>().Length){
                await _unitOfWork.SaveChangesAsync();
                return $"There is is {Enum.GetNames<TestType>().Length - bloodUnitTests.Count} tests left, please provide all test results regarding this blood unit.";
            }
            // Check if the blood unit passed all tests.
            foreach (var test in bloodUnitTests){
                if (test.TestResult == TestResult.Positive){

                    bloodUnit.Status = BloodUnitStatus.Expired;
                    await _unitOfWork.SaveChangesAsync();

                    return "This blood unit didn't pass all tests, it will be marked as expired!";
                }    
            }

            // If we are here, then the blood unit passed all tests, and can be considered safe (Available)
            bloodUnit.Status = BloodUnitStatus.Available;
            
            var donor = await _unitOfWork.Users.GetByIdAsync(bloodUnit.DonorId);

            if (donor is null){
                return "User does not exist";
            }

            donor.AdjustBloodBalance(1);

            donor.DonatedUnits.Add(bloodUnit);

            await _unitOfWork.SaveChangesAsync();

            return "Blood unit has been added to user and blood bank inventory Succussfully.";

        }
        else {
            testResult = new BloodTestResult {
                BloodUnitId = bloodUnit.Id,
                TestType = parseBloodTest,
                TestResult = TestResult.Positive
            };

            await _unitOfWork.SaveChangesAsync();
            return $"Blood unit appeared to be infected while taking the {parseBloodTest} test.";
        }
        
    }
}
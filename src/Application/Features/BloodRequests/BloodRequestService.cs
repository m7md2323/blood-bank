namespace Application.Features.BloodRequests;
using Domain.Interfaces;
using Domain.Entities;
using Domain.Enums;
using Domain.Specifications;
using Application.Common;
public class BloodRequestService : IBloodRequestService
{
    private readonly IUnitOfWork _unitOfWork;

    public BloodRequestService(IUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }

    public async Task <Result<bool>>SendBloodRequestAsync(Guid staffId, BloodRequestDto dto, CancellationToken ct)
    {
        var Staff = await _unitOfWork.Users.GetByIdAsync(staffId);

        if(Staff == null)
            throw new KeyNotFoundException($"Staff with ID '{staffId}' was not found.");
           
        var BloodBank = await _unitOfWork.BloodBanks.GetByIdAsync(dto.BloodBankId);

        if(BloodBank == null)
            throw new KeyNotFoundException($"Blood Bank with ID '{dto.BloodBankId}' was not found.");

        var BloodRequest = new BloodRequest
        {
            BloodBankId = dto.BloodBankId,
            BloodType = (BloodType)dto.BloodType,
            ComponentType = (ComponentType)dto.ComponentType,
            NumberOfUnits = (int)dto.NumberOfUnits,
            UrgencyLevel = (UrgencyLevel)dto.UrgencyLevel,
            Status = RequestStatus.Pending,
            CreatedAtUtc = DateTime.UtcNow,
        };
        
        return Result<bool>.Success(true);
    }

    public async Task<Result<bool>>HandleBloodRequestAsync(Guid staffId, Guid RequestId, CancellationToken ct)
    {
        var Staff = await _unitOfWork.Users.GetByIdAsync(staffId);
        var BloodRequest = await _unitOfWork.BloodRequests.GetByIdAsync(RequestId);

        if(Staff == null)
            throw new KeyNotFoundException($"Staff with ID '{staffId}' was not found.");
        
        if(BloodRequest == null)
            throw new KeyNotFoundException($"Blood Request with ID '{RequestId}' was not found.");

        BloodRequest.Status = RequestStatus.PartiallyFulfilled;
        BloodRequest.UrgencyLevel = UrgencyLevel.Routine;

        await _unitOfWork.BloodRequests.AddAsync(BloodRequest, ct);
        await _unitOfWork.SaveChangesAsync();

        return Result<bool>.Success(true);
    }

    public async Task <Result<IEnumerable<BloodRequest>>> GetHospitalRequestsAsync(Guid hospitalId, CancellationToken ct)
    {
        var hospital = await _unitOfWork.Users.GetByIdAsync(hospitalId);

        if(hospital == null)
            throw new KeyNotFoundException($"Hospital with ID '{hospitalId}' was not found.");

        var Specification =  new HospitalBloodRequestsSpecification(hospitalId, RequestStatus.Pending);
        var requests = await _unitOfWork.BloodRequests.ListAsync(Specification, ct);

        return Result<IEnumerable<BloodRequest>>.Success(requests);
    }
}
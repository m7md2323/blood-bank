using Domain.Common;
using Domain.Enums;

namespace Domain.Entities;

public class BloodUnit : BaseEntity 
{
    public bool IsDeleted { get; private set; }

    //System specific data

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

    //Methods


    // Blood unit Factory Methods Creator
    private BloodUnit() {}
    public static BloodUnit Create(
        Guid donorId,
        Guid bloodBankId,
        BloodType bloodType,
        ComponentType componentType,
        double volumeMl,
        DateTime collectionDate,
        DateTime expirationDate)
    {
    if (donorId == Guid.Empty)
        throw new ArgumentException("DonorId cannot be empty.", nameof(donorId));
    if (bloodBankId == Guid.Empty)
        throw new ArgumentException("BloodBankId cannot be empty.", nameof(bloodBankId));
    if (volumeMl <= 0)
        throw new ArgumentException("Volume must be greater than zero.", nameof(volumeMl));
    if (expirationDate <= collectionDate)
        throw new ArgumentException("Expiration date must be after collection date.", nameof(expirationDate));
    return new BloodUnit
    {
        DonorId = donorId,
        CurrentBloodBankId = bloodBankId,
        BloodType = bloodType,
        ComponentType = componentType,
        VolumeMl = volumeMl,
        CollectionDate = collectionDate,
        ExpirationDate = expirationDate,
        Status = BloodUnitStatus.Quarantined
    };
}
    public bool IsExpired()
    {
        return ExpirationDate <= DateTime.UtcNow;
    }

    public bool IsAvailable()
    {
        return Status == BloodUnitStatus.Available && !IsExpired();
    }

    public bool TransferToRecipient(Guid RecipientId)
    {
        if (IsAvailable())
        {
            RecipientAcceptorId = RecipientId;
            Status = BloodUnitStatus.Transfused;
            return true;
        }
            return false;
    }

    public bool TransferToHospital(Guid HospitalId)
    {
        if (IsAvailable())
        {
            CurrentHospitalId = HospitalId;
            Status = BloodUnitStatus.Transfused;
            return true;
        }
            return false;
    }

    public bool TransferToBloodBank(Guid BloodBankId)
    {
        if (IsAvailable())
        {
            CurrentBloodBankId = BloodBankId;
            Status = BloodUnitStatus.Transfused;
            return true;
        }
            return false;
    }

    public TimeSpan TimeLeft()
    {
        return ExpirationDate - DateTime.UtcNow;
    }

    public void SoftDelete()
    {
        IsDeleted = true;
    }

}

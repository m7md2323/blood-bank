using Domain.Common;
using Domain.Enums;

namespace Domain.Entities;

public class BloodUnit : BaseEntity 
{

    //System specific data

    public BloodType BloodType {set;get;}    
    public string ComponentType {set;get;} = string.Empty;
    public double VolumeMl {set;get;} = 0.0;
    public DateTime CollectionDate {set;get;}
    public DateTime ExpirationDate {set;get;}
    public BloodUnitStatus Status {set;get;} = BloodUnitStatus.Available;

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

}

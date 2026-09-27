using Domain.Common;
using Domain.Enums;

namespace Domain.Entities;

public enum UrgencyLevel
{
    Routine,      //Within 24-48 hours
    Urgent,       //Within 2-4 hours
    Emergency     //Needed immediately!
}

public class BloodRequest: BaseEntity{

    public BloodType BloodType {get;set;}
    public int NumberOfUnits {get;set;}
    public UrgencyLevel UrgencyLevel{get;set;} = UrgencyLevel.Routine;
    public RequestStatus Status { get; set; } = RequestStatus.Pending;
    public ComponentType ComponentType { get; set; }

    //This is the requester. 
    public Guid HospitalId {get;set;}
    public Hospital Hospital {get;set;} = null!;

    //This is the fullfiller.
    public Guid? BloodBankId {get;set;}
    public BloodBank? BloodBank {get;set;}

}
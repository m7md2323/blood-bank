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
    public ICollection<WalletTransaction> WalletTransactions { get; set; } = new List<WalletTransaction>();

    //Methods

    public void MarkAsUrgent()
    {
        UrgencyLevel = UrgencyLevel.Urgent;
    }
    public void ServeRequest()
    {
        Status = RequestStatus.Fulfilled;
    }
    
    public void RequestBlood(BloodBank BloodBank, int NumberOfUnits, BloodType Type, ComponentType Component, UrgencyLevel Urgency)
    {
        this.BloodType = Type;
        this.NumberOfUnits = NumberOfUnits;
        this.ComponentType = Component;
        this.UrgencyLevel = Urgency;

        if(!BloodBank.CanFulfill(this))
            throw new InvalidOperationException("The blood bank cannot fulfill this request.");

        BloodBankId = BloodBank.Id;
    }
    
}

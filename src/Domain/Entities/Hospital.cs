using Domain.Common;
using Domain.Enums;

namespace Domain.Entities;


public class Hospital : BaseEntity{
    
    public string Name {get;set;} = string.Empty;
    public string Email {get;set;} = string.Empty;
    public string PhoneNumber {get;set;} = string.Empty;

    public string City { get; set; } = string.Empty;
    public double Latitude { get; set; }
    public double Longitude { get; set; }

    //These units are stored in the ICU, or any where closer to the doctor.
    public ICollection<BloodUnit> StoredUnits{get;set;}
    //Nurses, Doctors, or any Hospital related work force. (All under Hopital Admin for now 19/9/2026)
    public ICollection<User> Staff {get;set;}
    public ICollection<BloodRequest> BloodRequests {get;set;}


}



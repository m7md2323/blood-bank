using Domain.Common;
using Domain.Enums;

namespace Domain.Entities;


public class BloodBank : BaseEntity{
    
    public string Name {get;set;} = string.Empty;
    public string Email {get;set;} = string.Empty;

    public string City { get; set; } = string.Empty;
    public double Latitude { get; set; }
    public double Longitude { get; set; }

    public ICollection<BloodUnit> StoredUnits{get;set;}
    public ICollection<User> Staff {get;set;}

    public ICollection<BloodRequest> FulfilledRequests {get;set;}


}



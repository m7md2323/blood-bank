using Domain.Common;
using Domain.Enums;

namespace Domain.Entities;

public class User : BaseEntity 
{
    //General information about users
    public string NationalNumber { get; set; } = string.Empty;
    public string FullName { get; set; } = string.Empty;
    public string Gender { get; set; } = string.Empty;
    public string Email { get; set; } = string .Empty;
    public string PhoneNumber { get; set; } = string.Empty;
    public string PasswordHash { get; set; } = string.Empty;
    public DateTime DateOfBirth { set; get; }

    //System specific data
    public BloodType BloodType { get; set; }
    public UserStatus Status { get; set; } = UserStatus.ActiveDonor;
    public UserRole Role { get; set; } = UserRole.StandardUser;
    public int BloodUnitsBalance { get; set; } = 0;

    //For locating Donors when blood units are needed
    public string City { get; set; } = string.Empty;
    public double Latitude { get; set; }
    public double Longitude { get; set; }

    //Collections that stores received or donated blood units
    public ICollection<BloodUnit> DonatedUnits { get; set; } = new List<BloodUnit>(); 
    public ICollection<BloodUnit> ReceivedUnits { get; set; } = new List<BloodUnit>(); 

    //Methods for marking a user as a donor or acceptor
    public void MarkAsDonor(){
        Status = UserStatus.ActiveDonor;
    }
    public void MarkAsAcceptor(){
        Status = UserStatus.MedicalAcceptor;
    }
}   

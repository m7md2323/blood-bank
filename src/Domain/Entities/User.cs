using Domain.Common;
using Domain.Enums;

namespace Domain.Entities;

public class User : BaseEntity 
{
    //General information about users
    public string NationalNumber { get; private set; } = string.Empty;
    public string FullName { get; set; } = string.Empty;
    public Gender Gender { get; private set; }
    public string Email { get; set; } = string .Empty;
    public string PhoneNumber { get; set; } = string.Empty;
    public string PasswordHash { get; set; } = string.Empty;
    public DateTime DateOfBirth { set; get; }

    //System specific data
    public BloodType BloodType { get; private set; }
    public UserStatus Status { get; private set; } = UserStatus.ActiveDonor;
    public UserRole Role { get; private set; } = UserRole.StandardUser;
    public int BloodUnitsBalance { get; private set; } = 0;

    //For locating Donors when blood units are needed
    public Location Location {get; private set;}

    //Collections that stores received or donated blood units
    public ICollection<BloodUnit> DonatedUnits { get; set; } = new List<BloodUnit>(); 
    public ICollection<BloodUnit> ReceivedUnits { get; set; } = new List<BloodUnit>(); 

    //To map EF Core relationship (Foreign Keys), 
    // and it's for staff members of Hospitals or Blood Banks.
    public Guid? HospitalId {get;set;}
    public Hospital? Hospital {get;set;}
    public Guid? BloodBankId {get;set;}  
    public BloodBank? BloodBank {get;set;}


    //Methods for manipulating the User Entity
    
    //Methods for marking a user as a donor or acceptor
    public void MarkAsDonor(){
        Status = UserStatus.ActiveDonor;
    }
    public void MarkAsAcceptor(){
        Status = UserStatus.MedicalAcceptor;
    }

    public void AdjustBloodBalance(int amount) {
        // when the amount is Positive, it means he just donated or recived blood units.
        // When the amount is Negative, it means he is donating or some of his blood units are beeing expired.
        if (amount < 0 && BloodUnitsBalance - amount <0)
            throw new InvalidOperationException("Insufficient blood unit balance.");

        BloodUnitsBalance+=amount;
    }

    public bool IsEligibleToDonate(){
        // Check if he is a Donor or not.
        if (Status != UserStatus.ActiveDonor)
            return false;

        // Fetch the last blood unit donated and check its date
        if (DonatedUnits.Any()){

            BloodUnit lastDonatedUnit = DonatedUnits.OrderByDescending(u => u.CollectionDate).First();
            // There is 4 types of blood donations: 
            // 1. Whole Blood (Can donate every 56 days)
            // 2. Power Red (Can donate every 112 days)
            // 3. Platelets (Can donate every 7 days)
            // 4. AB Elite Plasma (Can donate every 28 days)
            // For now we will cover the whole blood case.
            TimeSpan elapsed = DateTime.UtcNow - lastDonatedUnit.CollectionDate;

            if (elapsed.TotalDays < 56) 
                return false;
        }

        // If all conditions passes, return true.
        return true;
    }

    // Permissions related methods
    public bool IsStaff(){
        return Role != UserRole.StandardUser;
    }
    
    public bool CanFulfillRequests(){
        return (Role == UserRole.BloodBankAdmin || Role == UserRole.CentralAdmin);
    }

    public bool CanManageInventory(){
        return (Role == UserRole.BloodBankAdmin || Role == UserRole.CentralAdmin);
    }

    public bool CanDeferDonors(){
        return (Role == UserRole.BloodBankAdmin || Role == UserRole.CentralAdmin);
    }

    public bool CanSubmitBloodRequests(){
        return (Role == UserRole.HospitalAdmin || Role == UserRole.CentralAdmin);
    }

    public bool CanManageUsers(){
       return Role == UserRole.CentralAdmin;
    }
}   

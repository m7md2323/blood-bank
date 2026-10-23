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
    public bool IsDeleted { get; private set; }

    //For locating Donors when blood units are needed
    public Location Location {get; private set;} = null!;

    //Collections that stores received or donated blood units
    public ICollection<BloodUnit> DonatedUnits { get; set; } = []; 
    public ICollection<BloodUnit> ReceivedUnits { get; set; } = []; 

    //To map EF Core relationship (Foreign Keys), 
    // and it's for staff members of Hospitals or Blood Banks.
    public Guid? HospitalId {get;set;}
    public Hospital? Hospital {get;set;}
    public Guid? BloodBankId {get;set;}  
    public BloodBank? BloodBank {get;set;}


    // Private Constructors, we are implemnting Factory Method to create Usres.
    private User(){}
        private User(
        string nationalNumber,
        string fullName,
        Gender gender,
        string email,
        string phoneNumber,
        UserRole role,
        BloodType bloodType,
        DateTime dateOfBirth,
        string passwordHash,
        Location location)
    {
        NationalNumber = nationalNumber;
        FullName = fullName;
        Gender = gender;
        Email = email;
        PhoneNumber = phoneNumber;
        Role = role;
        BloodType = bloodType;
        DateOfBirth = dateOfBirth;
        PasswordHash = passwordHash;
        Location = location;
        Status = UserStatus.ActiveDonor;
        BloodUnitsBalance = 0;
        IsDeleted = false;
    }

    public static User Create(
        string nationalNumber,
        string fullName,
        Gender gender,
        string email,
        string phoneNumber,
        DateTime dateOfBirth,
        string passwordHash,
        Location location,
        BloodType bloodType = BloodType.OPositive,
        UserRole role = UserRole.StandardUser)
    {
        // First we validate all inputs.
        if (string.IsNullOrWhiteSpace(nationalNumber))
            throw new ArgumentException("National number cannot be empty.", nameof(nationalNumber));
        
        if (string.IsNullOrWhiteSpace(fullName))
            throw new ArgumentException("Full Name cannot be empty.", nameof(fullName));

         if (string.IsNullOrWhiteSpace(email))
            throw new ArgumentException("Email cannot be empty.", nameof(email));

        if (string.IsNullOrWhiteSpace(passwordHash))
            throw new ArgumentException("Password hash cannot be empty.", nameof(passwordHash));

        if (location is null)
            throw new ArgumentNullException(nameof(location), "User location is required.");

        if (dateOfBirth >= DateTime.UtcNow)
            throw new ArgumentException("Date of birth must be in the past.", nameof(dateOfBirth));

        // Then we return the new User object.
        return new User(
            nationalNumber.Trim(),
            fullName.Trim(),
            gender,
            email.Trim().ToLowerInvariant(),
            phoneNumber.Trim(),
            role,
            bloodType,
            dateOfBirth,
            passwordHash,
            location);

    }    

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
        if (amount < 0 && BloodUnitsBalance + amount < 0)
            throw new InvalidOperationException("Insufficient blood unit balance.");

        BloodUnitsBalance+=amount;
    }

    public void SoftDelete()
    {
        IsDeleted = true;
    }

    public bool IsEligibleToDonate(){
        // Check if he is a Donor or not.
        if (Status != UserStatus.ActiveDonor)
            return false;

        // Fetch the last blood unit donated and check its date
        if (DonatedUnits.Count != 0){

            BloodUnit lastDonatedUnit = DonatedUnits.OrderByDescending(u => u.CollectionDate).First();

            // This current implementation is based on this --> (https://www.khcc.jo/ar/donate-blood).

            TimeSpan elapsed = DateTime.UtcNow - lastDonatedUnit.CollectionDate;

            // The case if the blood donted is Platelets, it is recommended to only donate every 14 days.
            if (lastDonatedUnit.ComponentType == ComponentType.Platelets && elapsed.TotalDays < 14){
                return false;
            }

            // The case with Whole Blood,it is recommended for women to donate every 4 months, 
            // and every 3 months for men.
            if (lastDonatedUnit.ComponentType == ComponentType.WholeBlood){
                if (Gender == Gender.Female && elapsed.TotalDays < 120){
                    return false;
                }
                if (Gender == Gender.Male && elapsed.TotalDays < 90){
                    return false;
                }
            }
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

using Domain.Enums;

namespace Domain.Entities;

public class User
{
    public long UserId { get; set; }
    public string NationalNumber { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string PhoneNumber { get; set; } = string.Empty;
    public string PasswordHash { get; set; } = string.Empty;
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public GenderType Gender { get; set; }
    public DateOnly DateOfBirth { get; set; }
    public BloodGroup? BloodType { get; set; }
    public decimal? WeightKg { get; set; }
    public string? ResidenceGovernorate { get; set; }
    public string? ResidenceCity { get; set; }
    public string? AddressText { get; set; }
    public decimal? Latitude { get; set; }
    public decimal? Longitude { get; set; }
    public string? ProfilePhotoUrl { get; set; }
    public UserStatus Status { get; set; } = UserStatus.PendingVerification;
    public long? ManagedBloodBankId { get; set; }
    public long? ManagedHospitalId { get; set; }
    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
    public DateTimeOffset UpdatedAt { get; set; } = DateTimeOffset.UtcNow;

    // Navigation properties
    public BloodBank? ManagedBloodBank { get; set; }
    public Hospital? ManagedHospital { get; set; }
    public DonorProfile? DonorProfile { get; set; }
    public Patient? LinkedPatient { get; set; }

    public ICollection<UserRole> UserRoles { get; set; } = new List<UserRole>();
    public ICollection<UserMfaMethod> MfaMethods { get; set; } = new List<UserMfaMethod>();
    public ICollection<OtpChallenge> OtpChallenges { get; set; } = new List<OtpChallenge>();
    public ICollection<PasswordResetToken> PasswordResetTokens { get; set; } = new List<PasswordResetToken>();
    public ICollection<Donation> TestedDonations { get; set; } = new List<Donation>();
    public ICollection<BloodRequest> BloodRequests { get; set; } = new List<BloodRequest>();
    public ICollection<BloodRequestAllocation> AllocationsMade { get; set; } = new List<BloodRequestAllocation>();
    public ICollection<BloodUnitTransfer> TransfersCreated { get; set; } = new List<BloodUnitTransfer>();
    public ICollection<Message> SentMessages { get; set; } = new List<Message>();
    public ICollection<Message> ReceivedMessages { get; set; } = new List<Message>();
    public ICollection<Notification> Notifications { get; set; } = new List<Notification>();
}

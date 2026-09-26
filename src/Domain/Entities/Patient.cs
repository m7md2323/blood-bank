using Domain.Enums;

namespace Domain.Entities;

public class Patient
{
    public long PatientId { get; set; }
    public long RegisteredByHospitalId { get; set; }
    public long? LinkedUserId { get; set; }
    public string? NationalNumber { get; set; }
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public GenderType? Gender { get; set; }
    public DateOnly? DateOfBirth { get; set; }
    public BloodGroup? BloodType { get; set; }
    public string? PhoneNumber { get; set; }
    public string? MedicalRecordReference { get; set; }
    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
    public DateTimeOffset UpdatedAt { get; set; } = DateTimeOffset.UtcNow;

    // Navigation properties
    public Hospital RegisteredByHospital { get; set; } = null!;
    public User? LinkedUser { get; set; }
    public ICollection<BloodRequest> BloodRequests { get; set; } = new List<BloodRequest>();
    public ICollection<BloodCreditTransaction> ReceivedCreditTransactions { get; set; } = new List<BloodCreditTransaction>();
}

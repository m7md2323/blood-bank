using Domain.Enums;

namespace Domain.Entities;

public class Donation
{
    public long DonationId { get; set; }
    public long DonorUserId { get; set; }
    public long CenterId { get; set; }
    public BloodGroup BloodType { get; set; }
    public int Units { get; set; } = 1;
    public DateTimeOffset? ScheduledAt { get; set; }
    public DateTimeOffset? DonatedAt { get; set; }
    public DonationStatus Status { get; set; } = DonationStatus.Scheduled;
    public TestResult TestStatus { get; set; } = TestResult.Pending;
    public long? TestedByUserId { get; set; }
    public DateTimeOffset? TestedAt { get; set; }
    public string? RejectionReason { get; set; }
    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
    public DateTimeOffset UpdatedAt { get; set; } = DateTimeOffset.UtcNow;

    // Navigation properties
    public DonorProfile Donor { get; set; } = null!;
    public DonationCenter Center { get; set; } = null!;
    public User? TestedByUser { get; set; }
    public ICollection<BloodUnit> BloodUnits { get; set; } = new List<BloodUnit>();
    public BloodCreditTransaction? CreditTransaction { get; set; }
}

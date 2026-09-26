using Domain.Enums;

namespace Domain.Entities;

public class BloodUnit
{
    public long BloodUnitId { get; set; }
    public string UnitCode { get; set; } = string.Empty;
    public int VolumeMl { get; set; } = 450;
    public long? DonationId { get; set; }
    public BloodGroup BloodType { get; set; }
    public long? CurrentBloodBankId { get; set; }
    public long? CurrentHospitalId { get; set; }
    public BloodUnitStatus Status { get; set; } = BloodUnitStatus.Available;
    public DateTimeOffset CollectedAt { get; set; }
    public DateTimeOffset ExpiresAt { get; set; }
    public DateTimeOffset? TestedAt { get; set; }
    public TestResult TestStatus { get; set; } = TestResult.Pending;
    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
    public DateTimeOffset UpdatedAt { get; set; } = DateTimeOffset.UtcNow;

    // Navigation properties
    public Donation? Donation { get; set; }
    public BloodBank? CurrentBloodBank { get; set; }
    public Hospital? CurrentHospital { get; set; }
    public BloodRequestAllocation? Allocation { get; set; }
    public ICollection<BloodUnitTransferItem> TransferItems { get; set; } = new List<BloodUnitTransferItem>();
}

namespace Domain.Entities;

public class BloodRequestAllocation
{
    public long AllocationId { get; set; }
    public long BloodRequestId { get; set; }
    public long BloodUnitId { get; set; }
    public long? AllocatedByUserId { get; set; }
    public DateTimeOffset AllocatedAt { get; set; } = DateTimeOffset.UtcNow;

    // Navigation properties
    public BloodRequest BloodRequest { get; set; } = null!;
    public BloodUnit BloodUnit { get; set; } = null!;
    public User? AllocatedByUser { get; set; }
}

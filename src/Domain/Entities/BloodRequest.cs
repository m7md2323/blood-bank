using Domain.Enums;

namespace Domain.Entities;

public class BloodRequest
{
    public long BloodRequestId { get; set; }
    public long HospitalId { get; set; }
    public long? PatientId { get; set; }
    public long? RequestedByUserId { get; set; }
    public BloodGroup BloodType { get; set; }
    public int UnitsRequested { get; set; }
    public RequestPriority Priority { get; set; } = RequestPriority.Normal;
    public DateTimeOffset? NeededBy { get; set; }
    public RequestStatus Status { get; set; } = RequestStatus.Submitted;
    public string? Reason { get; set; }
    public decimal? BroadcastRadiusKm { get; set; }
    public string? BroadcastMessage { get; set; }
    public bool IsBroadcastActive { get; set; } = false;
    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
    public DateTimeOffset UpdatedAt { get; set; } = DateTimeOffset.UtcNow;

    // Navigation properties
    public Hospital Hospital { get; set; } = null!;
    public Patient? Patient { get; set; }
    public User? RequestedByUser { get; set; }
    public ICollection<BloodRequestAllocation> Allocations { get; set; } = new List<BloodRequestAllocation>();
    public ICollection<BloodCreditTransaction> CreditTransactions { get; set; } = new List<BloodCreditTransaction>();
    public ICollection<Message> Messages { get; set; } = new List<Message>();
    public ICollection<Notification> Notifications { get; set; } = new List<Notification>();
}

using Domain.Enums;

namespace Domain.Entities;

public class Notification
{
    public long NotificationId { get; set; }
    public long UserId { get; set; }
    public long? BloodRequestId { get; set; }
    public NotificationChannel Channel { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Body { get; set; } = string.Empty;
    public NotificationStatus Status { get; set; } = NotificationStatus.Queued;
    public DateTimeOffset QueuedAt { get; set; } = DateTimeOffset.UtcNow;
    public DateTimeOffset? SentAt { get; set; }
    public DateTimeOffset? ReadAt { get; set; }

    // Navigation properties
    public User User { get; set; } = null!;
    public BloodRequest? BloodRequest { get; set; }
}

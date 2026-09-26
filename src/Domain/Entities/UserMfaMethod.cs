using Domain.Enums;

namespace Domain.Entities;

public class UserMfaMethod
{
    public long MfaMethodId { get; set; }
    public long UserId { get; set; }
    public NotificationChannel Channel { get; set; }
    public string Destination { get; set; } = string.Empty;
    public bool IsVerified { get; set; } = false;
    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;

    // Navigation property
    public User User { get; set; } = null!;
}

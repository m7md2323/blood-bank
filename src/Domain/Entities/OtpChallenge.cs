using Domain.Enums;

namespace Domain.Entities;

public class OtpChallenge
{
    public long OtpChallengeId { get; set; }
    public long UserId { get; set; }
    public NotificationChannel Channel { get; set; }
    public string Destination { get; set; } = string.Empty;
    public string OtpHash { get; set; } = string.Empty;
    public DateTimeOffset ExpiresAt { get; set; }
    public DateTimeOffset? ConsumedAt { get; set; }
    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;

    // Navigation property
    public User User { get; set; } = null!;
}

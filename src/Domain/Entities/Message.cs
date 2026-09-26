namespace Domain.Entities;

public class Message
{
    public long MessageId { get; set; }
    public long SenderUserId { get; set; }
    public long RecipientUserId { get; set; }
    public long? BloodRequestId { get; set; }
    public string? Subject { get; set; }
    public string Body { get; set; } = string.Empty;
    public DateTimeOffset SentAt { get; set; } = DateTimeOffset.UtcNow;
    public DateTimeOffset? ReadAt { get; set; }

    // Navigation properties
    public User SenderUser { get; set; } = null!;
    public User RecipientUser { get; set; } = null!;
    public BloodRequest? BloodRequest { get; set; }
}

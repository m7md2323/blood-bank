namespace Domain.Entities;

public class DonorProfile
{
    public long UserId { get; set; }
    public bool IsAvailable { get; set; } = true;
    public DateTimeOffset? LastDonationAt { get; set; }
    public DateOnly? EligibleAfter { get; set; }
    public int CreditBalance { get; set; } = 0;
    public string? Notes { get; set; }
    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
    public DateTimeOffset UpdatedAt { get; set; } = DateTimeOffset.UtcNow;

    // Navigation properties
    public User User { get; set; } = null!;
    public ICollection<Donation> Donations { get; set; } = new List<Donation>();
    public ICollection<BloodCreditTransaction> EarnedOrTransferredTransactions { get; set; } = new List<BloodCreditTransaction>();
    public ICollection<BloodCreditTransaction> ReceivedDonorTransactions { get; set; } = new List<BloodCreditTransaction>();
}

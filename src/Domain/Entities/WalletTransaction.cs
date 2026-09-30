using Domain.Common;

namespace Domain.Entities;

public class WalletTransaction : BaseEntity
{
    // User who sends/gives the blood units
    public Guid UserId { get; set; }
    public User User { get; set; } = null!;

    // Number of blood units transferred
    public int Amount { get; set; }

    // User who receives the blood units
    public Guid ReceiverId { get; set; }
    public User Receiver { get; set; } = null!;

    // Donation related to this transaction
    public Guid DonationId { get; set; }
    public Donation Donation { get; set; } = null!;
}
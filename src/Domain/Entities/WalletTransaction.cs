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

    public Guid? BloodRequestId { get; set; }
    public BloodRequest? BloodRequest { get; set; }

    public static WalletTransaction CreateTransfer(
        User user,
        User receiver,
        Donation donation,
        int amount,
        BloodRequest? bloodRequest = null)
    {
        if (amount <= 0)
            throw new ArgumentOutOfRangeException(nameof(amount));

        user.AdjustBloodBalance(-amount);
        receiver.AdjustBloodBalance(amount);

        return new WalletTransaction
        {
            UserId = user.Id,
            User = user,
            ReceiverId = receiver.Id,
            Receiver = receiver,
            DonationId = donation.Id,
            Donation = donation,
            Amount = amount,
            BloodRequestId = bloodRequest?.Id,
            BloodRequest = bloodRequest
        };
    }

    //methods
    public bool HasSufficientBalance()
    {
        if (User.BloodUnitsBalance < Amount)
            return false;

        return true;
    }

    public void ValidateReceiver(User receiver)
    {
        if (receiver.Id == UserId)
            throw new InvalidOperationException("User cannot transfer blood units to themselves.");
    }
}

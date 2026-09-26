using Domain.Enums;

namespace Domain.Entities;

public class BloodCreditTransaction
{
    public long CreditTransactionId { get; set; }
    public CreditTransactionType TransactionType { get; set; }
    public long DonorUserId { get; set; }
    public long? RecipientDonorUserId { get; set; }
    public long? RecipientPatientId { get; set; }
    public long? DonationId { get; set; }
    public long? BloodRequestId { get; set; }
    public int Units { get; set; }
    public string? Notes { get; set; }
    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;

    // Navigation properties
    public DonorProfile Donor { get; set; } = null!;
    public DonorProfile? RecipientDonor { get; set; }
    public Patient? RecipientPatient { get; set; }
    public Donation? Donation { get; set; }
    public BloodRequest? BloodRequest { get; set; }
}

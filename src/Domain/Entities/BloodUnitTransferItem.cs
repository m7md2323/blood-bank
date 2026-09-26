namespace Domain.Entities;

public class BloodUnitTransferItem
{
    public long TransferId { get; set; }
    public long BloodUnitId { get; set; }

    // Navigation properties
    public BloodUnitTransfer Transfer { get; set; } = null!;
    public BloodUnit BloodUnit { get; set; } = null!;
}

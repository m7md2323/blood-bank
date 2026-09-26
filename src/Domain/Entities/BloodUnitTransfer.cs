using Domain.Enums;

namespace Domain.Entities;

public class BloodUnitTransfer
{
    public long TransferId { get; set; }
    public long? OriginBloodBankId { get; set; }
    public long? OriginHospitalId { get; set; }
    public long? DestinationBloodBankId { get; set; }
    public long? DestinationHospitalId { get; set; }
    public long? VehicleId { get; set; }
    public long? CreatedByUserId { get; set; }
    public TransferStatus Status { get; set; } = TransferStatus.Planned;
    public DateTimeOffset? DepartedAt { get; set; }
    public DateTimeOffset? ArrivedAt { get; set; }
    public string? Notes { get; set; }
    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;

    // Navigation properties
    public BloodBank? OriginBloodBank { get; set; }
    public Hospital? OriginHospital { get; set; }
    public BloodBank? DestinationBloodBank { get; set; }
    public Hospital? DestinationHospital { get; set; }
    public BloodTransportVehicle? Vehicle { get; set; }
    public User? CreatedByUser { get; set; }
    public ICollection<BloodUnitTransferItem> Items { get; set; } = new List<BloodUnitTransferItem>();
}

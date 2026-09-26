namespace Domain.Entities;

public class BloodTransportVehicle
{
    public long VehicleId { get; set; }
    public string VehicleCode { get; set; } = string.Empty;
    public long? BloodBankId { get; set; }
    public long? HospitalId { get; set; }
    public bool IsAvailable { get; set; } = true;
    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;

    // Navigation properties
    public BloodBank? BloodBank { get; set; }
    public Hospital? Hospital { get; set; }
    public ICollection<BloodUnitTransfer> Transfers { get; set; } = new List<BloodUnitTransfer>();
}

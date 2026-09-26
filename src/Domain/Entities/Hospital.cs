using Domain.Enums;

namespace Domain.Entities;

public class Hospital
{
    public long HospitalId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? PhoneNumber { get; set; }
    public string? Email { get; set; }
    public string Governorate { get; set; } = string.Empty;
    public string City { get; set; } = string.Empty;
    public string AddressText { get; set; } = string.Empty;
    public decimal? Latitude { get; set; }
    public decimal? Longitude { get; set; }
    public OrganizationStatus Status { get; set; } = OrganizationStatus.Active;
    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
    public DateTimeOffset UpdatedAt { get; set; } = DateTimeOffset.UtcNow;

    // Navigation properties
    public ICollection<User> ManagedUsers { get; set; } = new List<User>();
    public ICollection<DonationCenter> DonationCenters { get; set; } = new List<DonationCenter>();
    public ICollection<Patient> RegisteredPatients { get; set; } = new List<Patient>();
    public ICollection<BloodUnit> BloodUnits { get; set; } = new List<BloodUnit>();
    public ICollection<BloodRequest> BloodRequests { get; set; } = new List<BloodRequest>();
    public ICollection<BloodTransportVehicle> Vehicles { get; set; } = new List<BloodTransportVehicle>();
    public ICollection<BloodUnitTransfer> OriginTransfers { get; set; } = new List<BloodUnitTransfer>();
    public ICollection<BloodUnitTransfer> DestinationTransfers { get; set; } = new List<BloodUnitTransfer>();
}

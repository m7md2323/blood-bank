using Domain.Enums;

namespace Domain.Entities;

public class DonationCenter
{
    public long CenterId { get; set; }
    public string Name { get; set; } = string.Empty;
    public long? BloodBankId { get; set; }
    public long? HospitalId { get; set; }
    public string? PhoneNumber { get; set; }
    public string Governorate { get; set; } = string.Empty;
    public string City { get; set; } = string.Empty;
    public string AddressText { get; set; } = string.Empty;
    public decimal Latitude { get; set; }
    public decimal Longitude { get; set; }
    public string? OpeningHours { get; set; }
    public OrganizationStatus Status { get; set; } = OrganizationStatus.Active;
    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
    public DateTimeOffset UpdatedAt { get; set; } = DateTimeOffset.UtcNow;

    // Navigation properties
    public BloodBank? BloodBank { get; set; }
    public Hospital? Hospital { get; set; }
    public ICollection<Donation> Donations { get; set; } = new List<Donation>();
}

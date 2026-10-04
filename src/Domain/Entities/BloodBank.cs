using Domain.Common;
using Domain.Enums;

namespace Domain.Entities;


public class BloodBank : BaseEntity
{

    public string Name { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;

    public string City { get; set; } = string.Empty;
    public double Latitude { get; set; }
    public double Longitude { get; set; }

    public ICollection<BloodUnit> StoredUnits { get; set; }
    public ICollection<User> Staff { get; set; }

    public ICollection<BloodRequest> FulfilledRequests { get; set; }


    //Methods
    public bool HasAvailableUnits(BloodType Type, ComponentType Component)
    {
        return StoredUnits.Any(u => u.BloodType == Type && u.ComponentType == Component);
    }

    public int CountAvailableUnits(BloodType Type, ComponentType Component)
    {
        return StoredUnits.Count(u => u.BloodType == Type && u.ComponentType == Component);
    }

    public bool CanFulfill(BloodRequest request)
    {
        return request.NumberOfUnits >= StoredUnits.Count
           (u => u.BloodType == request.BloodType &&
       u.ComponentType == request.ComponentType);
    }

    public IEnumerable<BloodUnit> GetExpiredUnits()
    {
        return StoredUnits.Where(u => u.ExpirationDate <= DateTime.UtcNow);
    }

    public void MarkExpiredUnits()
    {
        foreach (BloodUnit Unit in StoredUnits)
            if (Unit.ExpirationDate <= DateTime.UtcNow)
                Unit.Status = BloodUnitStatus.Expired;
    }

    public bool IsStaffMember(Guid UserId)
    {
        return Staff.Any(u => u.BloodBankId == UserId);
    }

    /*public double DistanceTo() //AI GENERATED!
    {
        const double EarthRadiusKm = 6371.0;

        // Convert degrees to radians
        double dLat = ToRadians(targetLatitude - this.Latitude);
        double dLon = ToRadians(targetLongitude - this.Longitude);

        double originLatRad = ToRadians(this.Latitude);
        double targetLatRad = ToRadians(targetLatitude);

        // Haversine formula:
        // a = sin²(Δlat/2) + cos(lat1) * cos(lat2) * sin²(Δlon/2)
        // c = 2 * atan2(√a, √(1−a))
        // d = R * c
        double a = Math.Pow(Math.Sin(dLat / 2.0), 2) +
                   Math.Cos(originLatRad) * Math.Cos(targetLatRad) *
                   Math.Pow(Math.Sin(dLon / 2.0), 2);

        double c = 2.0 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1.0 - a));

        return EarthRadiusKm * c;
    }*/
}
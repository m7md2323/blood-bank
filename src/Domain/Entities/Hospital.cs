using Domain.Common;
using Domain.Enums;

namespace Domain.Entities;


public class Hospital : BaseEntity
{

    public string Name { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string PhoneNumber { get; set; } = string.Empty;

    Location Location { get; set; }

    //These units are stored in the ICU, or any where closer to the doctor.
    public ICollection<BloodUnit> StoredUnits { get; set; }
    //Nurses, Doctors, or any Hospital related work force. (All under Hopital Admin for now 19/9/2026)
    public ICollection<User> Staff { get; set; }
    public ICollection<BloodRequest> BloodRequests { get; set; }

    //Methods fro Hotpital Entity:

    public bool HasAvailableUnits(BloodType Type, ComponentType Component)
    {
        return StoredUnits.Any(u => u.BloodType == Type && u.ComponentType == Component);
    }

    public bool HasEmergencyRequests()
    {
        return BloodRequests.Any(u => u.UrgencyLevel == UrgencyLevel.Emergency);
    }

    public int CountAvailableUnits(BloodType Type, ComponentType Component)
    {
        return StoredUnits.Count(u => u.BloodType == Type && u.ComponentType == Component);
    }

    public bool IsStaffMember(Guid userId)
    {
        return Staff.Any(u => u.Id == userId && u.Role == UserRole.HospitalAdmin);
    }

    public bool HasPendingRequest(BloodType Type, ComponentType Component)
    {
        return BloodRequests.Any(u => u.BloodType == Type && u.ComponentType == Component &&
                                  u.Status == RequestStatus.Pending);
    }

    public IEnumerable<BloodUnit> GetExpiredUnits()
    {
        return StoredUnits.Where(u => u.ExpirationDate <= DateTime.UtcNow);
    }

    //The request is Active when its in pending or partiallyfulfilled
    public IEnumerable<BloodRequest> GetActiveRequests()
    {
        return BloodRequests.Where(u => u.Status == RequestStatus.PartiallyFulfilled ||
        u.Status == RequestStatus.Pending);
    }
}
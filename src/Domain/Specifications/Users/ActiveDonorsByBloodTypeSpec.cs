using Domain.Entities;
using Domain.Enums;
using Domain.Specifications;

namespace Domain.Specifications.Users;

// Fetch all active donors matching a specific blood type and location (city), and here city is optional. 
// Used to notify nearby donors when blood is urgently needed.
// This will be modifed later to implement a range based search,
// like if the blood bank want Active Donors within a 15KM radias from the blood bank location. 
public class ActiveDonorsByBloodTypeSpec : BaseSpecification<User>
{
    public ActiveDonorsByBloodTypeSpec(BloodType bloodType,string? city = null)
        : base(entity =>
        entity.BloodType == bloodType && 
        entity.Status == UserStatus.ActiveDonor &&
            (
            string.IsNullOrEmpty(city) || 
            entity.Location.City.ToLower() == city.ToLower()
            )
        )
    {
    }
}
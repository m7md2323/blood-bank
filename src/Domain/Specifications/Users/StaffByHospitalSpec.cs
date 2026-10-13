
using Domain.Entities;
using Domain.Specifications;

namespace Domain.Specifications.Users;

// Fetch all staff members assigned to a specific hospital. Used for hospital management.
public class StaffByHospitalSpec : BaseSpecification<User>
{
    public StaffByHospitalSpec(Guid hospitalId)
        : base(entity => entity.HospitalId == hospitalId)
    {
    }
}
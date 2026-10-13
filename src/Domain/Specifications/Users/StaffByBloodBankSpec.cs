
using Domain.Entities;
using Domain.Specifications;

namespace Domain.Specifications.Users;

// Fetch all staff members assigned to a specific blood bank. Used for blood bank management.
public class StaffByBloodBankSpec : BaseSpecification<User>
{
    public StaffByBloodBankSpec(Guid bloodBankId)
        : base(entity => entity.BloodBankId == bloodBankId)
    {
    }
}
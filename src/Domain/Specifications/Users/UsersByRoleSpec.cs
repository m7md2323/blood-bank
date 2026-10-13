
using Domain.Entities;
using Domain.Enums;
using Domain.Specifications;

namespace Domain.Specifications.Users;

// Fetch all users with a given UserRole, then sort them by name,
// and then apply pagging if requested.
// Used for admin management views.
public class UsersByRoleSpec : BaseSpecification<User>
{

    public UsersByRoleSpec(UserRole role, int? pageNumber = null, int? pageSize = null)
        : base(entity =>entity.Role == role)
    {
        ApplyOrderBy(u => u.FullName);
        if(pageNumber.HasValue && pageSize.HasValue){
            ApplyPaging((pageNumber.Value - 1) * pageSize.Value, pageSize.Value);
        }

    }
}

using Domain.Entities;
using Domain.Specifications;

namespace Domain.Specifications.Users;

// Fetch a single user by email address. 
// Used for login/auth.
public class UserByEmailSpec : BaseSpecification<User>
{
    public UserByEmailSpec(string email)
        : base(entity => entity.Email.ToLower() == email.Trim().ToLower())
    {
    }
}
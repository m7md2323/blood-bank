
using Domain.Entities;
using Domain.Specifications;

namespace Domain.Specifications.Users;

// Fetch a single user by national number. 
// Used during registration to prevent duplicates.
public class UserByNationalNumberSpec : BaseSpecification<User>
{
    public UserByNationalNumberSpec(string nationalNumber)
        : base(entity => entity.NationalNumber == nationalNumber)
    {
    }
}
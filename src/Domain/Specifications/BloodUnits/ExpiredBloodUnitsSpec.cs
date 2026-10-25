using Domain.Entities;
using Domain.Enums;

namespace Domain.Specifications;

public class ExpiredBloodUnitsSpec : BaseSpecification<BloodUnit> {

    public ExpiredBloodUnitsSpec()
        :base(entity => entity.ExpirationDate <= DateTime.UtcNow)
    {
        
    }

}
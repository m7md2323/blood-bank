using Domain.Entities;
using Domain.Enums;

namespace Domain.Specifications;

public class BloodUnitsByBloodBankSpec : BaseSpecification<BloodUnit> {

    public BloodUnitsByBloodBankSpec(Guid bloodBankId)
        :base(entity => entity.CurrentBloodBankId == bloodBankId)
    {
        ApplyOrderBy(entity => entity.CollectionDate);
    }

}
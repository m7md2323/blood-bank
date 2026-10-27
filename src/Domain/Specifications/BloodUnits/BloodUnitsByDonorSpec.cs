using Domain.Entities;

namespace Domain.Specifications;

public class BloodUnitsByDonorSpec : BaseSpecification<BloodUnit> {

    public BloodUnitsByDonorSpec(Guid donorId)
        :base(entity => entity.DonorId == donorId)
    {
        ApplyOrderBy(entity => entity.CollectionDate);
    }

}
using Domain.Entities;

namespace Domain.Specifications;

public class BloodUnitsByHospitalSpec : BaseSpecification<BloodUnit> {

    public BloodUnitsByHospitalSpec(Guid hospitalId)
        :base(entity => entity.CurrentHospitalId == hospitalId)
    {
        ApplyOrderBy(entity => entity.CollectionDate);
    }

}
using Domain.Entities;
using Domain.Enums;

namespace Domain.Specifications;

public class AvailableBloodUnitsByTypeSpec : BaseSpecification<BloodUnit> {

    public AvailableBloodUnitsByTypeSpec(BloodType bloodType)
        :base(entity => entity.BloodType == bloodType 
        && entity.IsDeleted == false
        && entity.IsAvailable() == true)
    {
        ApplyOrderBy(entity => entity.CollectionDate);
    }

}
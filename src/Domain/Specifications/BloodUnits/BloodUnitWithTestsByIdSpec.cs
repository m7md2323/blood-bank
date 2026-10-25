using Domain.Entities;

namespace Domain.Specifications.BloodUnits;

public class BloodUnitWithTestsByIdSpec : BaseSpecification<BloodUnit>
{
    public BloodUnitWithTestsByIdSpec(Guid bloodUnitId) 
        : base(u => u.Id == bloodUnitId)
    {
        AddInclude(u => u.TestResults);
    }
}

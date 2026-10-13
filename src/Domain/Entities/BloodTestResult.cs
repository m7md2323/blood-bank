using Domain.Common;
using Domain.Enums;

namespace Domain.Entities;

public class BloodTestResult : BaseEntity
{
    public TestType TestType { get; set; }
    public TestResult TestResult { get; set; } = TestResult.Pending;

    public Guid BloodUnitId { get; set; }
    public BloodUnit BloodUnit { get; set; } = null!;
}

namespace Application.Features.BloodInventory;

public record BloodTestOutcomeDto(
    Guid BloodUnitId,
    string TestType,
    string Status,        
    int RemainingTestsCount,
    bool IsApprovedForUse,
    string Message
);
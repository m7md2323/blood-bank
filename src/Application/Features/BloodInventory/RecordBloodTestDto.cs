namespace Application.Features.BloodInventory;

public record RecordBloodTestDto(
    Guid BloodUnitId,
    string TestType,
    bool IsPassed,
    string Notes
);
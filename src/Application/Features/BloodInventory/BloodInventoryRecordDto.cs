
namespace Application.Features.BloodInventory;

public record BloodInventoryRecordDto(
    string BloodType,
    string ComponentType,
    int AvailableCount,
    int QuarantinedCount,
    int ExpiredCount
);
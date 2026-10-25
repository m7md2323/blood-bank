namespace Application.Features.BloodInventory;

public record InventorySummaryDto(
    Guid BloodBankId,
    string BloodBankName,
    int TotalUnits,
    int TotalAvailableUnits,
    int TotalQuarantinedUnits,
    int TotalExpiredUnits,
    IReadOnlyList<BloodInventoryRecordDto> Breakdown
);
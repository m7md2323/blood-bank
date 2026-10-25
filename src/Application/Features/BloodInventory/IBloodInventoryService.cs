namespace Application.Features.BloodInventory;

public interface IBloodInventoryService {
    Task<bool> AddUnitAsync(Guid staffId, AddBloodUnitDto bloodUnitDto,CancellationToken ct);
    Task<InventorySummaryDto> GetInventorySummaryAsync(Guid staffId,CancellationToken ct);
    Task<string> RecordTestResultAsync(Guid staffId, RecordBloodTestDto bloodTestDto,CancellationToken ct);
}
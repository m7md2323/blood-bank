using Application.Common;

namespace Application.Features.BloodInventory;

public interface IBloodInventoryService {
    Task<Result<Guid>> AddUnitAsync(Guid staffId, AddBloodUnitDto bloodUnitDto,CancellationToken ct);
    Task<Result<InventorySummaryDto>> GetInventorySummaryAsync(Guid staffId,CancellationToken ct);
    Task<Result<BloodTestOutcomeDto>> RecordTestResultAsync(Guid staffId, RecordBloodTestDto bloodTestDto,CancellationToken ct);
}
using Application.Common;

namespace Application.Features.DonationCampaign;

public interface IDonationCampaignService
{
    Task<Result<Guid>> CreateCampaignAsync(Guid staffId, CreateDonationCampaignDto dto, CancellationToken ct = default);
    Task<Result<IReadOnlyList<DonationCampaignResponseDto>>> GetActiveCampaignsAsync(Guid staffId, CancellationToken ct = default);
    Task<Result<bool>> CancelCampaignAsync(Guid staffId, Guid campaignId, CancellationToken ct = default);
    Task<Result<bool>> CompleteCampaignAsync(Guid staffId, Guid campaignId, CancellationToken ct = default);
}
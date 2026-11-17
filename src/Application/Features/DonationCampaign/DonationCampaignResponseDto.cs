namespace Application.Features.DonationCampaign;

public record DonationCampaignResponseDto(
    Guid CampaignId,
    Guid BloodBankId,
    string BloodBankName,
    string BloodType,
    int TargetUnits,
    int ActualUnits,
    int UnitsRemaining,
    string Title,
    string Description,
    string Status,
    DateTime StartDate,
    DateTime EndDate,
    DateTime CreatedAtUtc
);
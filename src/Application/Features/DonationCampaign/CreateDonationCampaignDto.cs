namespace Application.Features.DonationCampaign;

public record CreateDonationCampaignDto(
    string BloodType,
    int TargetUnits,
    string Title,
    string Description,
    DateTime StartDate,
    DateTime EndDate
);
using Domain.Entities;
using Domain.Enums;

namespace Domain.Specifications;

public class CampaignsByBloodTypeSpec : BaseSpecification<DonationCampaign> {

    public CampaignsByBloodTypeSpec(BloodType bloodType)
        :base(entity => entity.BloodType == bloodType
        && entity.Status == DonationCampaignStatus.Active
        && entity.EndDate > DateTime.UtcNow)
    {
        ApplyOrderBy(entity => entity.StartDate);
    }

}

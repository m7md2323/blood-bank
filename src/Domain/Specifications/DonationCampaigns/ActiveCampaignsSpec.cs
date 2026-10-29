using Domain.Entities;
using Domain.Enums;

namespace Domain.Specifications;

public class ActiveCampaignsSpec : BaseSpecification<DonationCampaign> {

    public ActiveCampaignsSpec()
        :base(entity => entity.Status == DonationCampaignStatus.Active
        && entity.EndDate > DateTime.UtcNow)
    {
        ApplyOrderBy(entity => entity.StartDate);
    }

}

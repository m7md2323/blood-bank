using Domain.Entities;
using Domain.Enums;
namespace Domain.Specifications.DonationCampaigns;

public class ActiveCampaignsByBloodBankSpec : BaseSpecification<DonationCampaign> {

    public ActiveCampaignsByBloodBankSpec(Guid bloodBankId)
        :base(entity => entity.BloodBankId == bloodBankId &&
        entity.Status == DonationCampaignStatus.Active && 
        entity.EndDate > DateTime.UtcNow
        )
    {
        ApplyOrderBy(entity => entity.StartDate);
    }

}

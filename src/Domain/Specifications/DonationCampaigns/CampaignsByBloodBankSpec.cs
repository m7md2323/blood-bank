using Domain.Entities;

namespace Domain.Specifications.DonationCampaigns;

public class CampaignsByBloodBankSpec : BaseSpecification<DonationCampaign> {

    public CampaignsByBloodBankSpec(Guid bloodBankId)
        :base(entity => entity.BloodBankId == bloodBankId)
    {
        ApplyOrderBy(entity => entity.StartDate);
    }

}

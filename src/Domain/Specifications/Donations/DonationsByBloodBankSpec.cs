using Domain.Entities;

namespace Domain.Specifications;

public class DonationsByBloodBankSpec : BaseSpecification<Donation> {

    public DonationsByBloodBankSpec(Guid bloodBankId)
        :base(entity => entity.BloodBankId == bloodBankId)
    {
        ApplyOrderBy(entity => entity.DonationDate);
    }

}

using Domain.Entities;

namespace Domain.Specifications;

public class DonationsByDonorSpec : BaseSpecification<Donation> {

    public DonationsByDonorSpec(Guid donorId)
        :base(entity => entity.DonorId == donorId)
    {
        ApplyOrderBy(entity => entity.DonationDate);
    }

}

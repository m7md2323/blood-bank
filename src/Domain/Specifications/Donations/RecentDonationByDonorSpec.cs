using Domain.Entities;

namespace Domain.Specifications;

public class RecentDonationByDonorSpec : BaseSpecification<Donation> {

    public RecentDonationByDonorSpec(Guid donorId)
        :base(entity => entity.DonorId == donorId)
    {
        ApplyOrderByDescending(entity => entity.DonationDate);
        ApplyPaging(0, 1);
    }

}

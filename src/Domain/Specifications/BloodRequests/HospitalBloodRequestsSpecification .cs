using Domain.Entities;
using Domain.Enums;

namespace Domain.Specifications;

public class HospitalBloodRequestsSpecification  : BaseSpecification<BloodRequest> {

    public HospitalBloodRequestsSpecification(Guid hospitalId,RequestStatus Status)
        :base(entity => entity.HospitalId == hospitalId)
    {
        ApplyOrderBy(entity => entity.UrgencyLevel);
    }
}
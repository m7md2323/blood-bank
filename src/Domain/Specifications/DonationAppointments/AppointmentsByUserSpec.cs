using Domain.Entities;

namespace Domain.Specifications;

public class AppointmentsByUserSpec : BaseSpecification<DonationAppointment> {

    public AppointmentsByUserSpec(Guid userId)
        :base(entity => entity.UserId == userId)
    {
        ApplyOrderBy(entity => entity.ScheduledDate);
    }

}

using Domain.Entities;
using Domain.Enums;

namespace Domain.Specifications;

public class UpcomingAppointmentsSpec : BaseSpecification<DonationAppointment> {

    public UpcomingAppointmentsSpec()
        :base(entity => entity.Status == DonationAppointmentStatus.Scheduled
        && entity.ScheduledDate >= DateTime.UtcNow)
    {
        ApplyOrderBy(entity => entity.ScheduledDate);
    }

}

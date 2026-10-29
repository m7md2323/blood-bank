using Domain.Entities;
using Domain.Enums;

namespace Domain.Specifications;

public class ScheduledAppointmentsByBloodBankSpec : BaseSpecification<DonationAppointment> {

    public ScheduledAppointmentsByBloodBankSpec(Guid bloodBankId)
        :base(entity => entity.BloodBankId == bloodBankId
        && entity.Status == DonationAppointmentStatus.Scheduled
        && entity.ScheduledDate >= DateTime.UtcNow)
    {
        ApplyOrderBy(entity => entity.ScheduledDate);
    }

}

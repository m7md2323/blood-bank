using Domain.Common;
using Domain.Enums;

namespace Domain.Entities;

public class DonationAppointment : BaseEntity
{
    // Donor who booked the appointment
    public Guid UserId { get; set; }
    public User User { get; set; } = null!;

    // Blood bank where the donation will take place
    public Guid BloodBankId { get; set; }
    public BloodBank BloodBank { get; set; } = null!;

    public DateTime ScheduledDate { get; set; }

    public DonationAppointmentStatus Status { get; set; }
        = DonationAppointmentStatus.Scheduled;

    public string? Notes { get; set; }
}

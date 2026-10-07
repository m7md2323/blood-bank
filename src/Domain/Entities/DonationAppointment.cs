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

    // Methods

    public void AddNotes(string notes)
    {
        Notes = notes;
    }
    public void MarkAsCompleted()
    {
        Status = DonationAppointmentStatus.Completed;
    }
    public void MarkAsCancelled()
    {
        Status = DonationAppointmentStatus.Cancelled;
    }
    public void MarkAsMissed()
    {
        Status = DonationAppointmentStatus.Missed;
    }

    public TimeSpan TimeUntilAppointment()
    {   
        if(ScheduledDate < DateTime.UtcNow)
            throw new InvalidOperationException("The appointment date has already passed.");
        return ScheduledDate - DateTime.UtcNow;
    }
    
}

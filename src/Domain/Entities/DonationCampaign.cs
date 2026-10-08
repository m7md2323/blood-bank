using Domain.Common;
using Domain.Enums;

namespace Domain.Entities;

public class DonationCampaign : BaseEntity
{
    // Blood bank that created the campaign
    public Guid BloodBankId { get; set; }
    public BloodBank BloodBank { get; set; } = null!;

    // Blood type needed
    public BloodType BloodType { get; set; }

    public string Title { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;

    // Number of units the blood bank is trying to collect
    public int TargetUnits { get; set; }

    public DateTime StartDate { get; set; }
    public DateTime EndDate { get; set; }

    public DonationCampaignStatus Status { get; set; }
        = DonationCampaignStatus.Active;

    //New Fields
    public int ActualUnits { get; set; } = 0;

    // Methods
    public void Message(string Title, string Description)
    {
        this.Title = Title;
        this.Description = Description;
    }
    public void MarkAsCompleted()
    {
        Status = DonationCampaignStatus.Completed;
    }
    public void MarkAsCancelled()
    {
        Status = DonationCampaignStatus.Cancelled;
    }

    public TimeSpan TimeLeft()
    {
        if (EndDate < DateTime.UtcNow)
            throw new InvalidOperationException("The campaign has already ended.");

        return EndDate - DateTime.UtcNow;
    }

    public TimeSpan TimeUntilStart()
    {
        if (StartDate < DateTime.UtcNow)
            throw new InvalidOperationException("The campaign has already started.");

        return StartDate - DateTime.UtcNow;
    }

    public int UnitsRemaining()
    {
        return TargetUnits - ActualUnits;
    }
    
}
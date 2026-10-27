using Domain.Entities;

namespace Domain.Interfaces;

public interface IUnitOfWork: IDisposable {

    IRepository<User> Users { get; }
    IRepository<BloodBank> BloodBanks { get; }
    IRepository<BloodUnit> BloodUnits { get; }
    IRepository<Hospital> Hospitals { get; }
    IRepository<BloodRequest> BloodRequests { get; }
    IRepository<Donation> Donations { get; }
    IRepository<DonationAppointment> DonationAppointments { get; }
    IRepository<DonationCampaign> DonationCampaigns { get; }
    IRepository<Notification> Notifications { get; }
    IRepository<WalletTransaction> WalletTransactions { get; }
    IRepository<BloodTestResult> BloodTestResults { get; }
    // All chenges will be commited as one transaction.
    Task<int> SaveChangesAsync();

}
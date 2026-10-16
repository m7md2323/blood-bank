using Domain.Interfaces;
using Domain.Entities;

namespace Infrastructure.Data;

public class UnitOfWork : IUnitOfWork {
    private readonly ApplicationDbContext _context;

    private IRepository<User>? _users;
    private IRepository<BloodBank>? _bloodBanks;
    private IRepository<BloodUnit>? _bloodUnits;
    private IRepository<Hospital>? _hospitals;
    private IRepository<BloodRequest>? _bloodRequests;
    private IRepository<Donation>? _donations;
    private IRepository<DonationAppointment>? _donationAppointments;
    private IRepository<DonationCampaign>? _donationCampaigns;
    private IRepository<Notification>? _notifications;
    private IRepository<WalletTransaction>? _walletTransactions; 

    public UnitOfWork(ApplicationDbContext context){
        _context = context;
    }

    public IRepository<User> Users => _users ??= new Repository<User>(_context);
    public IRepository<BloodBank> BloodBanks => _bloodBanks ??= new Repository<BloodBank>(_context);
    public IRepository<BloodUnit> BloodUnits => _bloodUnits ??= new Repository<BloodUnit>(_context);
    public IRepository<Hospital> Hospitals => _hospitals ??= new Repository<Hospital>(_context);
    public IRepository<BloodRequest> BloodRequests => _bloodRequests ??= new Repository<BloodRequest>(_context);
    public IRepository<Donation> Donations => _donations ??= new Repository<Donation>(_context);
    public IRepository<DonationAppointment> DonationAppointments => _donationAppointments ??= new Repository<DonationAppointment>(_context);
    public IRepository<DonationCampaign> DonationCampaigns => _donationCampaigns ??= new Repository<DonationCampaign>(_context);
    public IRepository<Notification> Notifications => _notifications ??= new Repository<Notification>(_context);
    public IRepository<WalletTransaction> WalletTransactions => _walletTransactions ??= new Repository<WalletTransaction>(_context);
    
    public async Task<int> SaveChangesAsync(){
        return await _context.SaveChangesAsync();
    }

    public void Dispose(){

        _context.Dispose();
    }

}
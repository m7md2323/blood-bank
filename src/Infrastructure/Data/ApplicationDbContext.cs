using Domain.Entities;
using Domain.Common;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Data;

public sealed class ApplicationDbContext : DbContext
{
    private const string Schema = "smart_blood_bank";
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    public DbSet<BloodBank> BloodBanks => Set<BloodBank>();
    public DbSet<Hospital> Hospitals => Set<Hospital>();
    public DbSet<User> Users => Set<User>();
    public DbSet<Donation> Donations => Set<Donation>();
    public DbSet<BloodUnit> BloodUnits => Set<BloodUnit>();
    public DbSet<BloodRequest> BloodRequests => Set<BloodRequest>();
    public DbSet<WalletTransaction> WalletTransactions => Set<WalletTransaction>();
    public DbSet<DonationCampaign> DonationCampaigns => Set<DonationCampaign>();
    public DbSet<DonationAppointment> DonationAppointments => Set<DonationAppointment>();
    public DbSet<Notification> Notifications => Set<Notification>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema(Schema);
        modelBuilder.Entity<BloodBank>().ToTable("blood_banks", Schema).HasKey(x => x.Id);
        modelBuilder.Entity<Hospital>().ToTable("hospitals", Schema).HasKey(x => x.Id);
        modelBuilder.Entity<User>().ToTable("users", Schema).HasKey(x => x.Id);
        modelBuilder.Entity<Donation>().ToTable("donations", Schema).HasKey(x => x.Id);
        modelBuilder.Entity<BloodUnit>().ToTable("blood_units", Schema).HasKey(x => x.Id);
        modelBuilder.Entity<BloodRequest>().ToTable("blood_requests", Schema).HasKey(x => x.Id);
        modelBuilder.Entity<WalletTransaction>().ToTable("wallet_transactions", Schema).HasKey(x => x.Id);
        modelBuilder.Entity<DonationCampaign>().ToTable("donation_campaigns", Schema).HasKey(x => x.Id);
        modelBuilder.Entity<DonationAppointment>().ToTable("donation_appointments", Schema).HasKey(x => x.Id);
        modelBuilder.Entity<Notification>().ToTable("notifications", Schema).HasKey(x => x.Id);
        modelBuilder.Entity<WalletTransaction>().HasOne(x => x.User).WithMany().HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Restrict);
        modelBuilder.Entity<WalletTransaction>().HasOne(x => x.Receiver).WithMany().HasForeignKey(x => x.ReceiverId).OnDelete(DeleteBehavior.Restrict);
        modelBuilder.Entity<WalletTransaction>().HasOne(x => x.Donation) .WithMany().HasForeignKey(x => x.DonationId).OnDelete(DeleteBehavior.Restrict);
        modelBuilder.Entity<WalletTransaction>().HasOne(x => x.BloodRequest).WithMany(x => x.WalletTransactions).HasForeignKey(x => x.BloodRequestId).OnDelete(DeleteBehavior.Restrict);

        modelBuilder.Entity<User>().Property<uint>("xmin").HasColumnName("xmin").IsRowVersion();
        modelBuilder.Entity<User>().HasQueryFilter(x => !x.IsDeleted);
        modelBuilder.Entity<BloodUnit>().HasQueryFilter(x => !x.IsDeleted);

        // BloodUnit - Donor relationship
        modelBuilder.Entity<BloodUnit>().HasOne(x => x.Donor).WithMany(x => x.DonatedUnits).HasForeignKey(x => x.DonorId).OnDelete(DeleteBehavior.Restrict);
        // BloodUnit - Recipient relationship
        modelBuilder.Entity<BloodUnit>().HasOne(x => x.RecipientAcceptor).WithMany(x => x.ReceivedUnits).HasForeignKey(x => x.RecipientAcceptorId).OnDelete(DeleteBehavior.Restrict);

        ConfigureLocation(modelBuilder.Entity<BloodBank>().ComplexProperty(x => x.Location));
        ConfigureLocation(modelBuilder.Entity<Hospital>().ComplexProperty(x => x.Location));
        ConfigureLocation(modelBuilder.Entity<User>().ComplexProperty(x => x.Location));

        modelBuilder.Entity<User>().HasOne(x => x.Hospital).WithMany(x => x.Staff).HasForeignKey(x => x.HospitalId);
        modelBuilder.Entity<User>().HasOne(x => x.BloodBank).WithMany(x => x.Staff).HasForeignKey(x => x.BloodBankId);
        modelBuilder.Entity<BloodUnit>().HasOne(x => x.CurrentHospital).WithMany(x => x.StoredUnits).HasForeignKey(x => x.CurrentHospitalId);
        modelBuilder.Entity<BloodUnit>().HasOne(x => x.CurrentBloodBank).WithMany(x => x.StoredUnits).HasForeignKey(x => x.CurrentBloodBankId);
        modelBuilder.Entity<BloodRequest>().HasOne(x => x.Hospital).WithMany(x => x.BloodRequests).HasForeignKey(x => x.HospitalId);
        modelBuilder.Entity<BloodRequest>().HasOne(x => x.BloodBank).WithMany(x => x.FulfilledRequests).HasForeignKey(x => x.BloodBankId);
        modelBuilder.Entity<Donation>().HasOne(x => x.Donor).WithMany().HasForeignKey(x => x.DonorId);
        modelBuilder.Entity<Donation>().HasOne(x => x.Hospital).WithMany().HasForeignKey(x => x.HospitalId);
        modelBuilder.Entity<Donation>().HasOne(x => x.BloodBank).WithMany().HasForeignKey(x => x.BloodBankId);
        modelBuilder.Entity<Donation>().HasOne(x => x.BloodUnit).WithMany().HasForeignKey(x => x.BloodUnitId);
        modelBuilder.Entity<DonationAppointment>().HasOne(x => x.User).WithMany().HasForeignKey(x => x.UserId);
        modelBuilder.Entity<DonationAppointment>().HasOne(x => x.BloodBank).WithMany().HasForeignKey(x => x.BloodBankId);
        modelBuilder.Entity<DonationCampaign>().HasOne(x => x.BloodBank).WithMany().HasForeignKey(x => x.BloodBankId);

        // These references have foreign key properties but no navigation properties.
        modelBuilder.Entity<Notification>().HasOne<User>().WithMany().HasForeignKey(x => x.RecipientUserId);
        modelBuilder.Entity<Notification>().HasOne<Hospital>().WithMany().HasForeignKey(x => x.RecipientHospitalId);
        modelBuilder.Entity<Notification>().HasOne<BloodBank>().WithMany().HasForeignKey(x => x.RecipientBloodBankId);
        modelBuilder.Entity<Notification>().HasOne<BloodRequest>().WithMany().HasForeignKey(x => x.RelatedBloodRequestId);


        foreach (var entityType in modelBuilder.Model.GetEntityTypes()
                     .Where(x => x.ClrType.Namespace == "Domain.Entities"))
        {
            foreach (var property in entityType.GetProperties())
            {
                property.SetColumnName(ToSnakeCase(property.Name));
            }
        }
    }

    private static void ConfigureLocation(ComplexPropertyBuilder<Location> location)
    {
        location.IsRequired();
        location.Property(x => x.City).HasColumnName("location_city").IsRequired();
        location.Property(x => x.Latitude).HasColumnName("location_latitude");
        location.Property(x => x.Longitude).HasColumnName("location_longitude");
    }

    private static string ToSnakeCase(string value) => string.Concat(value.Select((character, index) =>
        index > 0 && char.IsUpper(character) ? "_" + char.ToLowerInvariant(character) : char.ToLowerInvariant(character).ToString()));
}

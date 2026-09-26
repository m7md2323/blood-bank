using Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Data;

public sealed class ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : DbContext(options)
{
    private const string S = "smart_blood_bank";

    public DbSet<Role> Roles => Set<Role>();
    public DbSet<BloodBank> BloodBanks => Set<BloodBank>();
    public DbSet<Hospital> Hospitals => Set<Hospital>();
    public DbSet<User> Users => Set<User>();
    public DbSet<UserRole> UserRoles => Set<UserRole>();
    public DbSet<UserMfaMethod> UserMfaMethods => Set<UserMfaMethod>();
    public DbSet<OtpChallenge> OtpChallenges => Set<OtpChallenge>();
    public DbSet<PasswordResetToken> PasswordResetTokens => Set<PasswordResetToken>();
    public DbSet<DonationCenter> DonationCenters => Set<DonationCenter>();
    public DbSet<DonorProfile> DonorProfiles => Set<DonorProfile>();
    public DbSet<Patient> Patients => Set<Patient>();
    public DbSet<Donation> Donations => Set<Donation>();
    public DbSet<BloodUnit> BloodUnits => Set<BloodUnit>();
    public DbSet<BloodRequest> BloodRequests => Set<BloodRequest>();
    public DbSet<BloodRequestAllocation> BloodRequestAllocations => Set<BloodRequestAllocation>();
    public DbSet<BloodCreditTransaction> BloodCreditTransactions => Set<BloodCreditTransaction>();
    public DbSet<BloodTransportVehicle> BloodTransportVehicles => Set<BloodTransportVehicle>();
    public DbSet<BloodUnitTransfer> BloodUnitTransfers => Set<BloodUnitTransfer>();
    public DbSet<BloodUnitTransferItem> BloodUnitTransferItems => Set<BloodUnitTransferItem>();
    public DbSet<Message> Messages => Set<Message>();
    public DbSet<Notification> Notifications => Set<Notification>();

    protected override void OnModelCreating(ModelBuilder b)
    {
        b.HasDefaultSchema(S);

        K<Role>(b, "roles", x => x.RoleId);
        K<BloodBank>(b, "blood_banks", x => x.BloodBankId);
        K<Hospital>(b, "hospitals", x => x.HospitalId);
        K<User>(b, "users", x => x.UserId);
        K<UserMfaMethod>(b, "user_mfa_methods", x => x.MfaMethodId);
        K<OtpChallenge>(b, "otp_challenges", x => x.OtpChallengeId);
        K<PasswordResetToken>(b, "password_reset_tokens", x => x.ResetTokenId);
        K<DonationCenter>(b, "donation_centers", x => x.CenterId);
        K<Patient>(b, "patients", x => x.PatientId);
        K<Donation>(b, "donations", x => x.DonationId);
        K<BloodUnit>(b, "blood_units", x => x.BloodUnitId);
        K<BloodRequest>(b, "blood_requests", x => x.BloodRequestId);
        K<BloodRequestAllocation>(b, "blood_request_allocations", x => x.AllocationId);
        K<BloodCreditTransaction>(b, "blood_credit_transactions", x => x.CreditTransactionId);
        K<BloodTransportVehicle>(b, "blood_transport_vehicles", x => x.VehicleId);
        K<BloodUnitTransfer>(b, "blood_unit_transfers", x => x.TransferId);
        K<Message>(b, "messages", x => x.MessageId);
        K<Notification>(b, "notifications", x => x.NotificationId);

        b.Entity<UserRole>().ToTable("user_roles", S).HasKey(x => new { x.UserId, x.RoleId });
        b.Entity<BloodUnitTransferItem>().ToTable("blood_unit_transfer_items", S).HasKey(x => new { x.TransferId, x.BloodUnitId });

        b.Entity<DonorProfile>().ToTable("donor_profiles", S).HasKey(x => x.UserId);
        b.Entity<DonorProfile>().Property(x => x.UserId).ValueGeneratedNever();

        R(b);

        foreach (var t in b.Model.GetEntityTypes())
        {
            foreach (var p in t.GetProperties())
            {
                p.SetColumnName(string.Concat(p.Name.Select((c, i) =>
                    i > 0 && char.IsUpper(c) ? "_" + char.ToLowerInvariant(c) : char.ToLowerInvariant(c).ToString())));
            }
        }
    }

    private static void K<T>(ModelBuilder b, string n, System.Linq.Expressions.Expression<Func<T, object>> k) where T : class
        => b.Entity<T>().ToTable(n, S).HasKey(k);

    private static void R(ModelBuilder b)
    {
        b.Entity<BloodUnitTransfer>()
            .HasOne(x => x.OriginBloodBank)
            .WithMany(x => x.OriginTransfers)
            .HasForeignKey(x => x.OriginBloodBankId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<BloodUnitTransfer>()
            .HasOne(x => x.DestinationBloodBank)
            .WithMany(x => x.DestinationTransfers)
            .HasForeignKey(x => x.DestinationBloodBankId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<BloodUnitTransfer>()
            .HasOne(x => x.OriginHospital)
            .WithMany(x => x.OriginTransfers)
            .HasForeignKey(x => x.OriginHospitalId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<BloodUnitTransfer>()
            .HasOne(x => x.DestinationHospital)
            .WithMany(x => x.DestinationTransfers)
            .HasForeignKey(x => x.DestinationHospitalId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<BloodUnitTransfer>()
            .HasOne(x => x.Vehicle)
            .WithMany(x => x.Transfers)
            .HasForeignKey(x => x.VehicleId)
            .OnDelete(DeleteBehavior.SetNull);

        b.Entity<BloodUnitTransfer>()
            .HasOne(x => x.CreatedByUser)
            .WithMany(x => x.TransfersCreated)
            .HasForeignKey(x => x.CreatedByUserId)
            .OnDelete(DeleteBehavior.SetNull);

        b.Entity<User>()
            .HasOne(x => x.ManagedBloodBank)
            .WithMany(x => x.ManagedUsers)
            .HasForeignKey(x => x.ManagedBloodBankId)
            .OnDelete(DeleteBehavior.SetNull);

        b.Entity<User>()
            .HasOne(x => x.ManagedHospital)
            .WithMany(x => x.ManagedUsers)
            .HasForeignKey(x => x.ManagedHospitalId)
            .OnDelete(DeleteBehavior.SetNull);

        b.Entity<User>()
            .HasOne(x => x.DonorProfile)
            .WithOne(x => x.User)
            .HasForeignKey<DonorProfile>(x => x.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        b.Entity<User>()
            .HasOne(x => x.LinkedPatient)
            .WithOne(x => x.LinkedUser)
            .HasForeignKey<Patient>(x => x.LinkedUserId)
            .OnDelete(DeleteBehavior.SetNull);

        b.Entity<UserRole>()
            .HasOne(x => x.User)
            .WithMany(x => x.UserRoles)
            .HasForeignKey(x => x.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        b.Entity<UserRole>()
            .HasOne(x => x.Role)
            .WithMany(x => x.UserRoles)
            .HasForeignKey(x => x.RoleId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<UserMfaMethod>()
            .HasOne(x => x.User)
            .WithMany(x => x.MfaMethods)
            .HasForeignKey(x => x.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        b.Entity<OtpChallenge>()
            .HasOne(x => x.User)
            .WithMany(x => x.OtpChallenges)
            .HasForeignKey(x => x.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        b.Entity<PasswordResetToken>()
            .HasOne(x => x.User)
            .WithMany(x => x.PasswordResetTokens)
            .HasForeignKey(x => x.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        b.Entity<DonationCenter>()
            .HasOne(x => x.BloodBank)
            .WithMany(x => x.DonationCenters)
            .HasForeignKey(x => x.BloodBankId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<DonationCenter>()
            .HasOne(x => x.Hospital)
            .WithMany(x => x.DonationCenters)
            .HasForeignKey(x => x.HospitalId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<Patient>()
            .HasOne(x => x.RegisteredByHospital)
            .WithMany(x => x.RegisteredPatients)
            .HasForeignKey(x => x.RegisteredByHospitalId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<Donation>()
            .HasOne(x => x.Donor)
            .WithMany(x => x.Donations)
            .HasForeignKey(x => x.DonorUserId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<Donation>()
            .HasOne(x => x.Center)
            .WithMany(x => x.Donations)
            .HasForeignKey(x => x.CenterId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<Donation>()
            .HasOne(x => x.TestedByUser)
            .WithMany(x => x.TestedDonations)
            .HasForeignKey(x => x.TestedByUserId)
            .OnDelete(DeleteBehavior.SetNull);

        b.Entity<BloodUnit>()
            .HasOne(x => x.Donation)
            .WithMany(x => x.BloodUnits)
            .HasForeignKey(x => x.DonationId)
            .OnDelete(DeleteBehavior.SetNull);

        b.Entity<BloodUnit>()
            .HasOne(x => x.CurrentBloodBank)
            .WithMany(x => x.BloodUnits)
            .HasForeignKey(x => x.CurrentBloodBankId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<BloodUnit>()
            .HasOne(x => x.CurrentHospital)
            .WithMany(x => x.BloodUnits)
            .HasForeignKey(x => x.CurrentHospitalId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<BloodRequest>()
            .HasOne(x => x.Hospital)
            .WithMany(x => x.BloodRequests)
            .HasForeignKey(x => x.HospitalId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<BloodRequest>()
            .HasOne(x => x.Patient)
            .WithMany(x => x.BloodRequests)
            .HasForeignKey(x => x.PatientId)
            .OnDelete(DeleteBehavior.SetNull);

        b.Entity<BloodRequest>()
            .HasOne(x => x.RequestedByUser)
            .WithMany(x => x.BloodRequests)
            .HasForeignKey(x => x.RequestedByUserId)
            .OnDelete(DeleteBehavior.SetNull);

        b.Entity<BloodRequestAllocation>()
            .HasOne(x => x.BloodRequest)
            .WithMany(x => x.Allocations)
            .HasForeignKey(x => x.BloodRequestId)
            .OnDelete(DeleteBehavior.Cascade);

        b.Entity<BloodRequestAllocation>()
            .HasOne(x => x.BloodUnit)
            .WithOne(x => x.Allocation)
            .HasForeignKey<BloodRequestAllocation>(x => x.BloodUnitId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<BloodRequestAllocation>()
            .HasOne(x => x.AllocatedByUser)
            .WithMany(x => x.AllocationsMade)
            .HasForeignKey(x => x.AllocatedByUserId)
            .OnDelete(DeleteBehavior.SetNull);

        b.Entity<BloodCreditTransaction>()
            .HasOne(x => x.Donor)
            .WithMany(x => x.EarnedOrTransferredTransactions)
            .HasForeignKey(x => x.DonorUserId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<BloodCreditTransaction>()
            .HasOne(x => x.RecipientDonor)
            .WithMany(x => x.ReceivedDonorTransactions)
            .HasForeignKey(x => x.RecipientDonorUserId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<BloodCreditTransaction>()
            .HasOne(x => x.RecipientPatient)
            .WithMany(x => x.ReceivedCreditTransactions)
            .HasForeignKey(x => x.RecipientPatientId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<BloodCreditTransaction>()
            .HasOne(x => x.Donation)
            .WithOne(x => x.CreditTransaction)
            .HasForeignKey<BloodCreditTransaction>(x => x.DonationId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<BloodCreditTransaction>()
            .HasOne(x => x.BloodRequest)
            .WithMany(x => x.CreditTransactions)
            .HasForeignKey(x => x.BloodRequestId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<BloodTransportVehicle>()
            .HasOne(x => x.BloodBank)
            .WithMany(x => x.Vehicles)
            .HasForeignKey(x => x.BloodBankId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<BloodTransportVehicle>()
            .HasOne(x => x.Hospital)
            .WithMany(x => x.Vehicles)
            .HasForeignKey(x => x.HospitalId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<BloodUnitTransferItem>()
            .HasOne(x => x.Transfer)
            .WithMany(x => x.Items)
            .HasForeignKey(x => x.TransferId)
            .OnDelete(DeleteBehavior.Cascade);

        b.Entity<BloodUnitTransferItem>()
            .HasOne(x => x.BloodUnit)
            .WithMany(x => x.TransferItems)
            .HasForeignKey(x => x.BloodUnitId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<Message>()
            .HasOne(x => x.SenderUser)
            .WithMany(x => x.SentMessages)
            .HasForeignKey(x => x.SenderUserId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<Message>()
            .HasOne(x => x.RecipientUser)
            .WithMany(x => x.ReceivedMessages)
            .HasForeignKey(x => x.RecipientUserId)
            .OnDelete(DeleteBehavior.Restrict);

        b.Entity<Message>()
            .HasOne(x => x.BloodRequest)
            .WithMany(x => x.Messages)
            .HasForeignKey(x => x.BloodRequestId)
            .OnDelete(DeleteBehavior.SetNull);

        b.Entity<Notification>()
            .HasOne(x => x.User)
            .WithMany(x => x.Notifications)
            .HasForeignKey(x => x.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        b.Entity<Notification>()
            .HasOne(x => x.BloodRequest)
            .WithMany(x => x.Notifications)
            .HasForeignKey(x => x.BloodRequestId)
            .OnDelete(DeleteBehavior.SetNull);
    }
}

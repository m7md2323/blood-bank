using Domain.Entities;
using Microsoft.EntityFrameworkCore;

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

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema(Schema);
        modelBuilder.Entity<BloodBank>().ToTable("blood_banks", Schema).HasKey(x => x.Id);
        modelBuilder.Entity<Hospital>().ToTable("hospitals", Schema).HasKey(x => x.Id);
        modelBuilder.Entity<User>().ToTable("users", Schema).HasKey(x => x.Id);
        modelBuilder.Entity<Donation>().ToTable("donations", Schema).HasKey(x => x.Id);
        modelBuilder.Entity<BloodUnit>().ToTable("blood_units", Schema).HasKey(x => x.Id);
        modelBuilder.Entity<BloodRequest>().ToTable("blood_requests", Schema).HasKey(x => x.Id);


        foreach (var entityType in modelBuilder.Model.GetEntityTypes()
                     .Where(x => x.ClrType.Namespace == "Domain.Entities"))
        {
            foreach (var property in entityType.GetProperties())
            {
                property.SetColumnName(ToSnakeCase(property.Name));
            }
        }
    }

    private static string ToSnakeCase(string value) => string.Concat(value.Select((character, index) =>
        index > 0 && char.IsUpper(character) ? "_" + char.ToLowerInvariant(character) : char.ToLowerInvariant(character).ToString()));
}

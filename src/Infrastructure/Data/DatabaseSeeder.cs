using Application.Interfaces;
using Domain.Common;
using Domain.Entities;
using Domain.Enums;
using Microsoft.EntityFrameworkCore;
using NetTopologySuite.Geometries;
using Location = Domain.Common.Location;

namespace Infrastructure.Data;

// AI Generated code!!
public static class DatabaseSeeder
{
    public static async Task SeedAsync(ApplicationDbContext context, IPasswordHasher passwordHasher)
    {
        // 1. Ensure migrations are applied
        await context.Database.MigrateAsync();

        // 2. Ensure a default Blood Bank exists
        var bloodBank = await context.BloodBanks.FirstOrDefaultAsync();
        if (bloodBank is null)
        {
            bloodBank = new BloodBank
            {
                Name = "Central Blood Bank",
                Email = "central@bloodbank.org",
                Location = new Location("Amman", new Point(35.9284, 31.9454) { SRID = 4326 })
            };

            await context.BloodBanks.AddAsync(bloodBank);
            await context.SaveChangesAsync();
        }

        // 3. Ensure a BloodBankAdmin user exists
        var adminEmail = "admin@bloodbank.org";
        var adminExists = await context.Users.AnyAsync(u => u.Email == adminEmail);

        if (!adminExists)
        {
            var admin = User.Create(
                nationalNumber: "9990001112",
                fullName: "System Admin",
                gender: Gender.Male,
                email: adminEmail,
                phoneNumber: "0790000000",
                dateOfBirth: new DateTime(1990, 1, 1, 0, 0, 0, DateTimeKind.Utc),
                passwordHash: passwordHasher.Hash("Admin@123456"),
                location: new Location("Amman", new Point(35.9284, 31.9454) { SRID = 4326 }),
                bloodType: BloodType.OPositive,
                role: UserRole.BloodBankAdmin
            );

            // Link admin to the blood bank
            admin.BloodBankId = bloodBank.Id;

            await context.Users.AddAsync(admin);
            await context.SaveChangesAsync();
        }
    }
}

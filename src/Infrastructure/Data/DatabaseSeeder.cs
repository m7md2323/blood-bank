using Application.Interfaces;
using Domain.Common;
using Domain.Entities;
using Domain.Enums;
using Microsoft.EntityFrameworkCore;
using NetTopologySuite.Geometries;

namespace Infrastructure.Data;

public static class DatabaseSeeder
{
    // Amman, Jordan coordinates
    private static readonly Domain.Common.Location AmmanLocation =
        new("Amman", new Point(35.9284, 31.9454));

    private const string AdminEmail = "admin@bloodbank.org";
    private const string AdminNationalId = "9990001112";
    private const string AdminPassword = "Admin@123456";

    public static async Task SeedAsync(ApplicationDbContext context, IPasswordHasher passwordHasher)
    {
        // 1. Ensure migrations are applied before seeding
        await context.Database.MigrateAsync();

        // 2. Seed default Blood Bank (idempotent check)
        var bloodBank = await context.BloodBanks
            .FirstOrDefaultAsync(b => b.Email == "central@bloodbank.org");

        if (bloodBank is null)
        {
            bloodBank = new BloodBank
            {
                Name = "Central Blood Bank",
                Email = "central@bloodbank.org",
                Location = AmmanLocation
            };

            context.BloodBanks.Add(bloodBank);
            await context.SaveChangesAsync();
        }

        // 3. Seed default BloodBankAdmin user (idempotent check by NationalID)
        var adminExists = await context.Users
            .IgnoreQueryFilters() // Bypass soft-delete filter to also catch deleted users
            .AnyAsync(u => u.NationalNumber == AdminNationalId || u.Email == AdminEmail);

        if (!adminExists)
        {
            var admin = User.Create(
                nationalNumber: AdminNationalId,
                fullName: "System Admin",
                gender: Gender.Male,
                email: AdminEmail,
                phoneNumber: "0790000000",
                dateOfBirth: new DateTime(1990, 1, 1, 0, 0, 0, DateTimeKind.Utc),
                passwordHash: passwordHasher.Hash(AdminPassword),
                location: AmmanLocation,
                bloodType: BloodType.OPositive,
                role: UserRole.BloodBankAdmin
            );

            admin.BloodBankId = bloodBank.Id;

            context.Users.Add(admin);
            await context.SaveChangesAsync();
        }
    }
}

using Domain.Entities;
using Domain.Enums;
using Domain.Common;

namespace Tests.UnitTests.Common;

public class HelperMetods {
public static User CreateTestUser(
        string nationalNumber = "9901012345",
        string fullName = "Test User",
        Gender gender = Gender.Male,
        string email = "test@example.com",
        string phoneNumber = "0791234567",
        DateTime? dateOfBirth = null,
        string passwordHash = "dummy_hashed_password",
        BloodType bloodType = BloodType.OPositive)
    {
        return User.Create(
            nationalNumber: nationalNumber,
            fullName: fullName,
            gender: gender,
            email: email,
            phoneNumber: phoneNumber,
            dateOfBirth: dateOfBirth ?? DateTime.UtcNow.AddYears(-22), // Valid age (> 18)
            passwordHash: passwordHash,
            location: new Location("Amman", new NetTopologySuite.Geometries.Point(35.9284, 31.9454)),
            bloodType: bloodType
        );
    }

    public static BloodUnit CreateTestBloodUnit(
        Guid? donorId = null,
        Guid? bloodBankId = null,
        BloodType bloodType = BloodType.OPositive,
        ComponentType componentType = ComponentType.WholeBlood,
        double volumeMl = 450.0,
        DateTime? collectionDate = null,
        DateTime? expirationDate = null,
        BloodUnitStatus status = BloodUnitStatus.Available)
    {
        var collected = collectionDate ?? DateTime.UtcNow;
        var expired = expirationDate ?? (collected > DateTime.UtcNow ? collected.AddDays(35) : DateTime.UtcNow.AddDays(35));

        var unit = BloodUnit.Create(
            donorId: donorId ?? Guid.NewGuid(),
            bloodBankId: bloodBankId ?? Guid.NewGuid(),
            bloodType: bloodType,
            componentType: componentType,
            volumeMl: volumeMl,
            collectionDate: collected,
            expirationDate: expired
        );

        unit.Status = status;
        return unit;
    }
}
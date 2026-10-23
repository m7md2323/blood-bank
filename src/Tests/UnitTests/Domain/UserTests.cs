using System.Text.Encodings.Web;
using Domain.Entities;
using Tests.UnitTests.Common;
using Domain.Enums;
using FluentAssertions;
using Xunit;

namespace UnitTests.Domain;

public class UserTests
{
    [Fact]
    public void AdjustBloodBalance_ShouldIncreaseBalance_WhenPositiveAmountGiven()
    {
        // Arrange
        var user = HelperMetods.CreateTestUser();

        // Act
        user.AdjustBloodBalance(2);

        // Assert
        user.BloodUnitsBalance.Should().Be(2);
    }

    [Fact]
    public void AdjustBloodBalance_ShouldThrowInvalidOperationException_WhenBalanceBecomesNegative()
    {
        // Arrange
        var user = HelperMetods.CreateTestUser(); // Initial balance is 0

        // Act
        var act = () => user.AdjustBloodBalance(-1);

        // Assert
        act.Should().Throw<InvalidOperationException>()
            .WithMessage("Insufficient blood unit balance.");
    }

    [Fact]
    public void MarkAsDonor_ShouldUpdateStatusToActiveDonor()
    {
        // Arrange
        var user = HelperMetods.CreateTestUser();
        user.MarkAsAcceptor();

        // Act
        user.MarkAsDonor();

        // Assert
        user.Status.Should().Be(UserStatus.ActiveDonor);
    }

    [Fact]
    public void IsEligibleToDonate_ShouldReturnFalseOnNonActiveDonor()
    {
        // Arrange
        var user = HelperMetods.CreateTestUser();
        
        // Act
        user.MarkAsAcceptor();
        var isEligible = user.IsEligibleToDonate();

        // Assert
        isEligible.Should().BeFalse();
        
    }

    [Fact]
    public void IsEligibleToDonate_ShouldReturnFalseIfTypeIsPlateletsAndLessThan14Days()
    {
        // Arrange
        var user = HelperMetods.CreateTestUser();
        user.DonatedUnits.Add(
            new BloodUnit{
                ComponentType=ComponentType.Platelets,
                CollectionDate= DateTime.UtcNow.AddDays(-10)
            }
        );

        // Act
        var isEligible = user.IsEligibleToDonate();

        // Assert
        isEligible.Should().BeFalse();
        
    }

}


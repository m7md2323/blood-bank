using Domain.Enums;

namespace Application.Features.Auth;

public record UserResponseDto (

    Guid Id,
    string FullName,
    string Email,
    string PhoneNumber,
    BloodType BloodType,
    int BloodUnitsBalance

);
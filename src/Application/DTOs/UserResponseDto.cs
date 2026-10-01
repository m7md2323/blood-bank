using Domain.Enums;

namespace Application.DTOs;

public record UserResponseDto (

    Guid Id,
    string FullName,
    string Email,
    string PhoneNumber,
    BloodType BloodType,
    int BloodUnitsBalance

);
using Domain.Enums;

namespace Application.Features.Auth;

public record RegisterUserDto (
    string FirstName,
    string LastName,
    Gender Gender,
    string NationalID,
    string Email,
    string Phone,
    DateTime Date,
    string Password,
    string PasswordConfirm
);
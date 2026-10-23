namespace Application.Features.Auth;

public record LoginUserDto (
    string NationalID,
    string Password
);
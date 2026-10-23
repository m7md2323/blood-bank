
namespace Application.Features.Auth;


public record AuthResponse (
    string Token,
    DateTime ExpiresAt,
    UserResponseDto? User = null,
    string? RefreshToken = null
);
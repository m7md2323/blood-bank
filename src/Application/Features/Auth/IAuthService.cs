namespace Application.Features.Auth;

public interface IAuthService {

    // Returns the auth response containing the JWT token and user info.
    Task<AuthResponse?> LoginAsync(LoginUserDto loginUserDto,CancellationToken ct);
    Task<AuthResponse?> RegisterAsync(RegisterUserDto registerUserDto,CancellationToken ct);
}
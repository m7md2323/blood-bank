using Application.Features.Auth;
using Microsoft.AspNetCore.Mvc;

namespace Web.Contollers;

[Route("api/[controller]")]
[ApiController]
public class AuthController : ControllerBase {
    private readonly IAuthService _authService;

    public AuthController(IAuthService authService){
        _authService = authService;
    }

    [HttpPost("register")]
    [ProducesResponseType(typeof(AuthResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<AuthResponse>> Register(
        [FromBody] RegisterUserDto registerUserDto, 
        CancellationToken ct)
    {
        var response = await _authService.RegisterAsync(registerUserDto,ct);

        if (response is null) {
            return BadRequest(new {message = "User with this NationalID already exists."});
        }

        return Ok(response);

    }

    [HttpPost("login")]
    [ProducesResponseType(typeof(AuthResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<AuthResponse>> Login(
        [FromBody] LoginUserDto loginUserDto, 
        CancellationToken ct)
    {
        var response = await _authService.LoginAsync(loginUserDto,ct);

        if (response is null) {
            return Unauthorized(new {message = "Invalid User National ID or Password"});
        }

        return Ok(response);

    }
    

}
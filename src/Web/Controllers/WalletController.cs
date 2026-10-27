using System.Security.Claims;
using Application.Features.Wallet;
using Microsoft.AspNetCore.Mvc;

namespace Web.Controllers;

[Route("api/[controller]")]
[ApiController]
public class WalletController : ControllerBase
{
    private readonly IWalletService _walletService;

    public WalletController(IWalletService walletService)
    {
        _walletService = walletService;
    }

    [HttpGet("credit")]
    [ProducesResponseType(typeof(UserCreditResponseDto), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<ActionResult<UserCreditResponseDto>> GetCredit(CancellationToken ct)
    {
        var UserId = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (string.IsNullOrEmpty(UserId) || !Guid.TryParse(UserId, out var userId))
            return Unauthorized(new { message = "Invalid or missing user identity." });

        var response = await _walletService.GetUserCreditAsync(userId, ct);

        if (response is null)
            return BadRequest(new { message = "User wallet balance not found." });

        return Ok(response);
    }

    [HttpPost("transfer")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Transfer(
        [FromBody] TransferBloodUnitsDto transferBloodUnitsDto,
        CancellationToken ct)
    {
        var UserId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        
        if (string.IsNullOrEmpty(UserId) || !Guid.TryParse(UserId, out var userId))
            return Unauthorized(new { message = "Invalid or missing user identity." });

        
        var result = await _walletService.TransferCreditsAsync(userId, transferBloodUnitsDto, ct);
        
        if (result == false)
            return BadRequest(new { message = "Failed to transfer blood units." });

        return Ok(new { message = "Blood units transferred successfully." });
    }
}
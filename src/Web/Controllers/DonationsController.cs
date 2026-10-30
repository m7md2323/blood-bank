using System.Security.Claims;
using Application.Features.Donations;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Web.Controllers;

[Authorize]
[Route("api/donations")]
[ApiController]
public class DonationsController : ControllerBase
{
    private readonly IDonationService _donationService;

    public DonationsController(IDonationService donationService)
    {
        _donationService = donationService;
    }

    [HttpGet("visits")]
    [ProducesResponseType(typeof(IReadOnlyList<VisitResponse>), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<IReadOnlyList<VisitResponse>>> GetVisits(CancellationToken ct)
    {
        var userIdAsString = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (!Guid.TryParse(userIdAsString, out var userId))
            return Unauthorized(new { message = "Invalid or missing user identity." });

        try
        {
            var response = await _donationService.GetUserVisitsAsync(userId, ct);
            return Ok(response);
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(new { message = ex.Message });
        }
    }

    [HttpPost("appointments")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> BookAppointment(
        [FromBody] BookDonationAppointmentDto dto,
        CancellationToken ct)
    {
        var userIdAsString = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (!Guid.TryParse(userIdAsString, out var userId))
            return Unauthorized(new { message = "Invalid or missing user identity." });

        var result = await _donationService.BookDonationAsync(userId, dto, ct);

        if (result == false)
            return BadRequest(new { message = "Failed to book donation appointment." });

        return Ok(new { message = "Donation appointment booked successfully." });
    }
}

using System.Security.Claims;
using Application.Features.BloodRequests;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Application.Common;

namespace Web.Controllers;

[Authorize(Roles = "HospitalAdmin")]
[Route("api/[controller]")]
[ApiController]
public class BloodRequestsController : ControllerBase
{
    private readonly IBloodRequestService _bloodRequestService;

    public BloodRequestsController(IBloodRequestService bloodRequestService){
        _bloodRequestService = bloodRequestService;
    }

    [HttpPost("requests")]
    public async Task<ActionResult> SubmitBloodRequestAsync([FromBody] BloodRequestDto BloodRequestDto, CancellationToken ct){
        var staffIdAsString = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (!Guid.TryParse(staffIdAsString,out var staffId)){
            return BadRequest(new {Message = "The current staff does not exist, or there is an error parsing the staff Id"});
        }
        var response = await _bloodRequestService.SendBloodRequestAsync(staffId, BloodRequestDto, ct);

        return response.ErrorType switch
        {
            ErrorType.None => Ok(response.Value),
            ErrorType.NotFound => NotFound(new { Message = response.ErrorMessage }),
            ErrorType.Unauthorized => Forbid(),
            ErrorType.Conflict => Conflict(new { Message = response.ErrorMessage }),
            _ => BadRequest(new { Message = response.ErrorMessage })
        };
    }

    [HttpGet("hospital/{hospitalId:guid}")]
    public async Task<ActionResult<BloodRequestDto>> ListHospitalActiveRequests(CancellationToken ct){
        
        var HospitalIdAsString = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (!Guid.TryParse(HospitalIdAsString,out var HospitalId)){
            return BadRequest(new {Message = "The current Hospital id does not exist, or there is an error parsing the Hospital Id"});
        }
        var response = await _bloodRequestService.GetHospitalRequestsAsync(HospitalId,ct);

        return response.ErrorType switch
        {
            ErrorType.None => Ok(response.Value),
            ErrorType.NotFound => NotFound(new { Message = response.ErrorMessage }),
            ErrorType.Unauthorized => Forbid(),
            ErrorType.Conflict => Conflict(new { Message = response.ErrorMessage }),
            _ => BadRequest(new { Message = response.ErrorMessage })
        };
    }
}
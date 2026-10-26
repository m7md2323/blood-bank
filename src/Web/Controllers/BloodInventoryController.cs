using System.Security.Claims;
using Application.Features.BloodInventory;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Application.Common;

namespace Web.Controllers;

[Authorize(Roles = "BloodBankAdmin")]
[Route("api/[controller]")]
[ApiController]
public class BloodInventoryController : ControllerBase
{
    private readonly IBloodInventoryService _bloodInventoryService;

    public BloodInventoryController(IBloodInventoryService bloodInventoryService){
        _bloodInventoryService = bloodInventoryService;
    }

    [HttpPost("add_unit")]
    public async Task<ActionResult> AddUnitAsync([FromBody] AddBloodUnitDto bloodUnitDto, CancellationToken ct){
        var staffIdAsString = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (!Guid.TryParse(staffIdAsString,out var staffId)){
            return BadRequest(new {Message = "The current staff does not exist, or there is an error parsing the staff Id"});
        }
        var response = await _bloodInventoryService.AddUnitAsync(staffId,bloodUnitDto,ct);

        return response.ErrorType switch
        {
            ErrorType.None => Ok(response.Value),
            ErrorType.NotFound => NotFound(new { Message = response.ErrorMessage }),
            ErrorType.Unauthorized => Forbid(),
            ErrorType.Conflict => Conflict(new { Message = response.ErrorMessage }),
            _ => BadRequest(new { Message = response.ErrorMessage })
        };
    }

    [HttpPost("test_result")]
    public async Task<ActionResult> RecordTestResultAsync([FromBody] RecordBloodTestDto bloodTestDto, CancellationToken ct){
        var staffIdAsString = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (!Guid.TryParse(staffIdAsString,out var staffId)){
            return BadRequest(new {Message = "The current staff does not exist, or there is an error parsing the staff Id"});
        }
        var response = await _bloodInventoryService.RecordTestResultAsync(staffId,bloodTestDto,ct);

        return response.ErrorType switch
        {
            ErrorType.None => Ok(response.Value),
            ErrorType.NotFound => NotFound(new { Message = response.ErrorMessage }),
            ErrorType.Unauthorized => Forbid(),
            ErrorType.Conflict => Conflict(new { Message = response.ErrorMessage }),
            _ => BadRequest(new { Message = response.ErrorMessage })
        };
        
    }

    [HttpGet("summary")]
    public async Task<ActionResult<InventorySummaryDto>> Summary(CancellationToken ct){
        var staffIdAsString = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (!Guid.TryParse(staffIdAsString,out var staffId)){
            return BadRequest(new {Message = "The current staff does not exist, or there is an error parsing the staff Id"});
        }
        var response = await _bloodInventoryService.GetInventorySummaryAsync(staffId,ct);

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
using System.Security.Claims;
using Application.Features.DonationCampaign;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Application.Common;
using Domain.Entities;

namespace Web.Controllers;

[Authorize(Roles = "BloodBankAdmin")]
[Route("api/[controller]")]
[ApiController]
public class DonationCampaignController : ControllerBase {
    private readonly IDonationCampaignService _donationCampaignService;

    public DonationCampaignController(IDonationCampaignService donationCampaignService){
        _donationCampaignService = donationCampaignService;
    }

    [HttpPost("create_campaign")]
    public async Task<ActionResult> CreateCampaign([FromBody] CreateDonationCampaignDto campaignDto,CancellationToken ct){
        var staffIdAsString = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (!Guid.TryParse(staffIdAsString,out var staffId)){
            return BadRequest(new {Message = "The current staff does not exist, or there is an error parsing the staff Id"});
        }
        var response = await _donationCampaignService.CreateCampaignAsync(staffId,campaignDto,ct);

        return response.ErrorType switch
        {
            ErrorType.None => Ok(response.Value),
            ErrorType.NotFound => NotFound(new { Message = response.ErrorMessage }),
            ErrorType.Unauthorized => Forbid(),
            ErrorType.Conflict => Conflict(new { Message = response.ErrorMessage }),
            _ => BadRequest(new { Message = response.ErrorMessage })
        };
    }

    [HttpGet("campaigns")]
    public async Task<ActionResult> GetCampaings(CancellationToken ct){
        var staffIdAsString = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (!Guid.TryParse(staffIdAsString,out var staffId)){
            return BadRequest(new {Message = "The current staff does not exist, or there is an error parsing the staff Id"});
        }
        var response = await _donationCampaignService.GetActiveCampaignsAsync(staffId,ct);

        return response.ErrorType switch
        {
            ErrorType.None => Ok(response.Value),
            ErrorType.NotFound => NotFound(new { Message = response.ErrorMessage }),
            ErrorType.Unauthorized => Forbid(),
            ErrorType.Conflict => Conflict(new { Message = response.ErrorMessage }),
            _ => BadRequest(new { Message = response.ErrorMessage })
        };
    }

    [HttpPatch("{campaignId}/complete")]
    public async Task<ActionResult> CompleteCampaign(Guid campaignId,CancellationToken ct){
        var staffIdAsString = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (!Guid.TryParse(staffIdAsString,out var staffId)){
            return BadRequest(new {Message = "The current staff does not exist, or there is an error parsing the staff Id"});
        }
        var response = await _donationCampaignService.CompleteCampaignAsync(staffId,campaignId,ct);

        return response.ErrorType switch
        {
            ErrorType.None => Ok(response.Value),
            ErrorType.NotFound => NotFound(new { Message = response.ErrorMessage }),
            ErrorType.Unauthorized => Forbid(),
            ErrorType.Conflict => Conflict(new { Message = response.ErrorMessage }),
            _ => BadRequest(new { Message = response.ErrorMessage })
        };
    }

    [HttpPatch("{campaignId}/cancel")]
    public async Task<ActionResult> CancelCampaign(Guid campaignId,CancellationToken ct){
        var staffIdAsString = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (!Guid.TryParse(staffIdAsString,out var staffId)){
            return BadRequest(new {Message = "The current staff does not exist, or there is an error parsing the staff Id"});
        }
        var response = await _donationCampaignService.CancelCampaignAsync(staffId,campaignId,ct);

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
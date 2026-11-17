
using Domain.Entities;
using Domain.Interfaces;
using Domain.Specifications;
using Domain.Enums;
using Domain.Common;
using Application.Common;
using Domain.Specifications.DonationCampaigns;
using System.Threading.Tasks.Dataflow;

namespace Application.Features.DonationCampaign;

public class DonationCampaignService : IDonationCampaignService
{
    private readonly IUnitOfWork _unitOfWork;

    public DonationCampaignService(IUnitOfWork unitOfWork)
    {
        _unitOfWork = unitOfWork;
    }

    //Creates a new Donation Campaign for a specific blood bank by a staff member.
    public async Task<Result<Guid>> CreateCampaignAsync(Guid staffId, CreateDonationCampaignDto dto, CancellationToken ct)
    {
        var staff = await _unitOfWork.Users.GetByIdAsync(staffId);

        if (staff is null)
            throw new KeyNotFoundException($"Staff with ID '{staffId}' was not found.");

        if (staff.BloodBankId is null)
            throw new KeyNotFoundException($"Staff with ID '{staffId}' does not have a blood bank Id property.");
        
        var bloodBank = await _unitOfWork.BloodBanks.GetByIdAsync(staff.BloodBankId.Value);

        if (bloodBank is null)
            return Result<Guid>.NotFound($"Blood Bank with ID '{staff.BloodBankId.Value}' was not found.");

        if (!Enum.TryParse<BloodType>(dto.BloodType, true, out var parseBloodType))
        {
            return Result<Guid>.Failure("Invalid blood type provided.", ErrorType.ParseFaild); ;
        }
        var newCampaign = new Domain.Entities.DonationCampaign
        {
            BloodBankId = (Guid)staff.BloodBankId,
            BloodType = parseBloodType,
            TargetUnits = dto.TargetUnits,
            StartDate = dto.StartDate,
            EndDate = dto.EndDate,
        };

        newCampaign.Message(dto.Title, dto.Description);

        await _unitOfWork.DonationCampaigns.AddAsync(newCampaign, ct);
        await _unitOfWork.SaveChangesAsync();

        return Result<Guid>.Success(newCampaign.Id);

    }

    //Returns Active Donation Campaigns for a specific blood bank.
    public async Task<Result<IReadOnlyList<DonationCampaignResponseDto>>> GetActiveCampaignsAsync(Guid staffId, CancellationToken ct)
    {
        var staff = await _unitOfWork.Users.GetByIdAsync(staffId);
        if (staff is null){
            return Result<IReadOnlyList<DonationCampaignResponseDto>>.NotFound($"Thers is no staff member with Id: {staffId}");
        }

        if (staff.BloodBankId is null)
            return Result<IReadOnlyList<DonationCampaignResponseDto>>.Unauthorized("Staff member is not assigned to a blood bank.");

        var bloodBankId = staff.BloodBankId.Value;
        
        var bloodBank = await _unitOfWork.BloodBanks.GetByIdAsync(bloodBankId);

        if (bloodBank is null){
            return Result<IReadOnlyList<DonationCampaignResponseDto>>.NotFound($"Thers is no blood bank with Id: {bloodBankId}");
        }

        var campaignsByBloodBankSpec = new ActiveCampaignsByBloodBankSpec(bloodBankId);
        var campaigns = await _unitOfWork.DonationCampaigns.ListAsync(campaignsByBloodBankSpec,ct);
        

        if (campaigns is null){
            return Result<IReadOnlyList<DonationCampaignResponseDto>>.NotFound($"Thers is no Donation Campaigns in this blood bank. Id: {bloodBankId}");
        }
        
        var campaignsResponse = campaigns.Select(campaign => new DonationCampaignResponseDto(
            campaign.Id,
            campaign.BloodBankId,
            bloodBank.Name,
            campaign.BloodType.ToString(),
            campaign.TargetUnits,
            campaign.ActualUnits,
            campaign.UnitsRemaining(),
            campaign.Title,
            campaign.Description,
            campaign.Status.ToString(),
            campaign.StartDate,
            campaign.EndDate,
            campaign.CreatedAtUtc
        )).ToList();
        
        return Result<IReadOnlyList<DonationCampaignResponseDto>>.Success(campaignsResponse);
        
    }
    public async Task<Result<bool>> CompleteCampaignAsync(Guid staffId, Guid campaignId, CancellationToken ct)
    {
        var staff = await _unitOfWork.Users.GetByIdAsync(staffId);
        var campaign = await _unitOfWork.DonationCampaigns.GetByIdAsync(campaignId);

        if (staff is null){
            return Result<bool>.NotFound($"Thers is no staff member with Id: {staffId}");
        }

        if (campaign is null){
            return Result<bool>.NotFound($"Thers is no campaign with Id: {campaignId}");
        }

        if (campaign.BloodBankId != staff.BloodBankId){
            return Result<bool>.Unauthorized($"staff member with name : {staff.FullName}, Id : {staff.Id} does not have access to this campaign (Id : {campaignId})");
        }

         if (campaign.Status != DonationCampaignStatus.Active){
            return Result<bool>.NotFound($"This Campaign is not Active, you can't Complete an Unactive campaign!");

        }
        campaign.MarkAsCompleted();

        await _unitOfWork.SaveChangesAsync();

        return Result<bool>.Success(true);

    }

    public async Task<Result<bool>> CancelCampaignAsync(Guid staffId, Guid campaignId, CancellationToken ct = default)
    {
        var staff = await _unitOfWork.Users.GetByIdAsync(staffId);
        var campaign = await _unitOfWork.DonationCampaigns.GetByIdAsync(campaignId);

        if (staff is null){
            return Result<bool>.NotFound($"Thers is no staff member with Id: {staffId}");
        }

        if (campaign is null){
            return Result<bool>.NotFound($"Thers is no campaign with Id: {campaignId}");
        }

        if (campaign.BloodBankId != staff.BloodBankId){
            return Result<bool>.Unauthorized($"staff member with name : {staff.FullName}, Id : {staff.Id} does not have access to this campaign (Id : {campaignId})");
        }

        if (campaign.Status != DonationCampaignStatus.Active){
            return Result<bool>.NotFound($"This Campaign is not Active, you can't cancel an Unactive campaign!");

        }

        campaign.MarkAsCancelled();

        await _unitOfWork.SaveChangesAsync();

        return Result<bool>.Success(true);

    }

}
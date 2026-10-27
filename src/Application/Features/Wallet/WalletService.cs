using Domain.Entities;
using Domain.Interfaces;
using Domain.Specifications;
using Domain.Enums;

namespace Application.Features.Wallet;


public class WalletService : IWalletService
{
    private readonly IUnitOfWork _unitOfWork;
    public WalletService(IUnitOfWork unitOfWork){
        _unitOfWork = unitOfWork;
    }
    public async Task<UserCreditResponseDto> GetUserCreditAsync(Guid userId, CancellationToken ct)
    {
        var user = await _unitOfWork.Users.GetByIdAsync(userId);

        if (user == null)
            throw new KeyNotFoundException($"User with ID '{userId}' was not found.");

        return new UserCreditResponseDto(user.BloodUnitsBalance);
    }
    public async Task<bool> TransferCreditsAsync(Guid userId, TransferBloodUnitsDto dto, CancellationToken ct)
    {
        var sender = await _unitOfWork.Users.GetByIdAsync(userId);
        var recipient = await _unitOfWork.Users.GetByIdAsync(dto.RecipientUserId);

        if(sender == null || recipient == null)
            return false;

        if(userId == dto.RecipientUserId)
            return false;
        
        if(dto.UnitsCount <= 0)
            return false;
        
        if(sender.BloodUnitsBalance < dto.UnitsCount)
            return false;
        
        sender.AdjustBloodBalance((int)-dto.UnitsCount);
        recipient.AdjustBloodBalance((int)dto.UnitsCount);

        var transaction = new WalletTransaction
        {
            UserId = sender.Id,
            ReceiverId = recipient.Id,
            Amount = (int)dto.UnitsCount,
            CreatedAtUtc = DateTime.UtcNow
        };

        await _unitOfWork.WalletTransactions.AddAsync(transaction, ct);
        await _unitOfWork.SaveChangesAsync();
        
        return true;
    }
}
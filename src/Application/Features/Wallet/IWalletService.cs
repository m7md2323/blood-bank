


namespace Application.Features.Wallet;

public interface IWalletService
{
Task<UserCreditResponseDto> GetUserCreditAsync(Guid userId, CancellationToken ct);
Task<bool> TransferCreditsAsync(Guid userId, TransferBloodUnitsDto dto, CancellationToken ct);
}
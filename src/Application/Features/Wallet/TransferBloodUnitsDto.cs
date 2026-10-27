
namespace Application.Features.Wallet;

public record TransferBloodUnitsDto(Guid RecipientUserId, double UnitsCount, string Reason);


namespace Application.Features.Donations;

public interface IDonationService
{
    Task<IReadOnlyList<VisitResponse>> GetUserVisitsAsync(Guid userId, CancellationToken ct);
    Task<bool> BookDonationAsync(Guid userId, BookDonationAppointmentDto dto, CancellationToken ct);
}

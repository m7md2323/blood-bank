namespace Application.Features.BloodRequests;
using Domain.Entities;
using Application.Common;

public interface IBloodRequestService
{
    Task <Result<bool>>SendBloodRequestAsync(Guid staffId, BloodRequestDto dto, CancellationToken ct);
    Task <Result<bool>>HandleBloodRequestAsync(Guid staffId, Guid RequestId, CancellationToken ct);
    Task <Result<IEnumerable<BloodRequest>>> GetHospitalRequestsAsync(Guid hospitalId, CancellationToken ct);
}
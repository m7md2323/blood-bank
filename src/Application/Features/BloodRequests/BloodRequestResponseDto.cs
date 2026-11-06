namespace Application.Features.BloodRequests;

public record BloodRequestResponseDto(Guid RequestId, Guid HospitalId, Guid BloodBankId, string Status, int RequestedUnits);
namespace Application.Features.BloodRequests;

using Domain.Entities;
using Domain.Enums;

public record BloodRequestDto(Guid BloodBankId, BloodType BloodType, ComponentType ComponentType,
                        int NumberOfUnits, UrgencyLevel UrgencyLevel, string Notes);
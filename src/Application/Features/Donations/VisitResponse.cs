namespace Application.Features.Donations;

public record VisitResponse(
    Guid Id,
    DateTime VisitDate,
    string VisitType,
    string VisitLocation,
    string VisitStatus
);

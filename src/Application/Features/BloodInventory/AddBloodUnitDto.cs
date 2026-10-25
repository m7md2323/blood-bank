namespace Application.Features.BloodInventory;
/*
    public BloodType BloodType {set;get;}    
    public ComponentType ComponentType {set;get;}
    public double VolumeMl {set;get;} = 0.0;
    public DateTime CollectionDate {set;get;}
    public DateTime ExpirationDate {set;get;}
    // Units remain quarantined until screening is approved.
    public BloodUnitStatus Status {set;get;} = BloodUnitStatus.Quarantined;
*/
public record AddBloodUnitDto(
    Guid DonorId,
    string ComponentType,
    string BloodType,
    double VolumeMl,
    DateTime CollectionDate,
    DateTime ExpirationDate
);
namespace Domain.Enums;

public enum UserStatus
{
    ActiveDonor,      // Default: Eligible to donate blood and send credits
    MedicalAcceptor,  // Active patient in need/receiving blood (Ineligible to donate)
    Deferred          // Temporarily/permanently deferred for health reasons
}
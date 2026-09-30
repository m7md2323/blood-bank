namespace Domain.Enums;

public enum Permission
{
    //NOTE: i didnt understand the provided link correctly

    // this way will use if statement before calling any method

    // e.g. before calling UpdateBloodInventory() Method
    // if( User.Permission & Permission.UpdateBloodInventory == Permission.UpdateBloodInventory )
    //      UpdateBloodInventory() 

    //CentralAdmin
    All = -1,

    //BloodBankAdmin
    ViewBloodInventory = 1,
    UpdateBloodInventory = 2,
    SendNotification = 4,
    ManageTransportaionTrucks = 8,

    //HospitalAdmin
    RequestBlood = 16,
    
    //StandardUser
    TransferBlood = 32,
    ViewNearbyDonationPoints = 64,
}
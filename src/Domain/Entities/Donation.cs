
using Domain.Common;

namespace Domain.Entities
{
    public class Donation : BaseEntity
    {
        public Guid DonorId {get;set;}
        public User Donor {get;set;}

        public Guid? HospitalId {get;set;}
        public Hospital? Hospital {get;set;}
        public Guid? BloodBankId {get;set;}  
        public BloodBank? BloodBank {get;set;}

        public Guid BloodUnitId {get;set;}
        public BloodUnit BloodUnit {get;set;}

        public DateTime DonationDate {get;set;}

    }
}

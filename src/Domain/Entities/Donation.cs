
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

        //New Property
        public DateTime NextEligibleDonationDate {get;set;}//This is calculated based on the donation date

        //Methods

        public TimeSpan CalculateTimeForNextDonation()
        {
            switch(BloodUnit.ComponentType)
            {
                case Enums.ComponentType.WholeBlood:
                    return TimeSpan.FromDays(56); 

                case Enums.ComponentType.Plasma:
                    return TimeSpan.FromDays(28);

                case Enums.ComponentType.Platelets:
                    return TimeSpan.FromDays(7);

                case Enums.ComponentType.WhiteBloodCells:
                    return TimeSpan.FromDays(14);
                    
                case Enums.ComponentType.RedBloodCells:
                    return TimeSpan.FromDays(112);

                default:
                    throw new InvalidOperationException("Unknown blood component type.");
            }
        }
        public void SetNextEligibleDonationDate(TimeSpan duration)
        {
            NextEligibleDonationDate = DonationDate + duration;
        }

        public Guid DonatedFor()
        {
            if (HospitalId.HasValue)
                return HospitalId.Value;
            else if (BloodBankId.HasValue)
                return BloodBankId.Value;
            else
                throw new InvalidOperationException("Donation is not associated with any hospital or blood bank.");
        }
        // Additional method: DonationSummary()
    }
}

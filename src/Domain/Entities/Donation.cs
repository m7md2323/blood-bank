
using Domain.Common;

namespace Domain.Entities
{
    internal class Donation : BaseEntity
    {
        public string DonorId { get; set; } = string.Empty;

        //public Donor Donor;
        public BloodBank BloodBank { get; set; } = string.Empty;
        public BloodUnit BloodUnit { get; set; } = string.Empty;

        public DateTime DontaionDate { get; set; }

    }
}

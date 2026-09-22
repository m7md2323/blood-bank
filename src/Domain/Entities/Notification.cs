

using Domain.Common;

namespace Domain.Entities
{
    public class Notification:BaseEntity
    {
        public string Title { get; set; } = string.Empty;
        public string Message { get; set; } = string.Empty;


        public bool IsRead { get; set; }

        public DateTime? ReadAtUtc { get; set; }

        public Guid? RecipientUserId { get; set; }
        public Guid? RecipientHospitalId { get; set; }
        public Guid? RecipientBloodBankId { get; set; }
        public Guid? RelatedBloodRequestId { get; set; }
    }
}

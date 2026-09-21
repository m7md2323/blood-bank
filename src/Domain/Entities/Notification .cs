

using Domain.Common;

namespace Domain.Entities
{
    internal class Notification:BaseEntity
    {
        public string NotificationID { get; set; } = string.Empty;
        public string Title { get; set; } = string.Empty;
        public string Message { get; set; } = string.Empty;

        //NotificationType NotificationType { get; set; }

        public bool IsRead { get; set; }

        public DateTime ReadAtUtc { get; set; }

        public DateTime CreatedAtUtc { get; set; }
        public Guid? RecipientUserId { get; set; }
        public Guid? RecipientHospitalId { get; set; }
        public Guid? RecipientBloodBankId { get; set; }
        public Guid? RelatedBloodRequestId { get; set; }
    }
}

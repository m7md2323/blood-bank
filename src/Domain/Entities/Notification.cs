

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

        void MarkAsRead()
        {
            IsRead = true;
            ReadAtUtc = DateTime.UtcNow;
        }
        void MarkAsUnread()
        {
            IsRead = false;
            ReadAtUtc = null;
        }
        
        public void SendNotification(string title, string message)
        {
            Title = title;
            Message = message;
            MarkAsUnread();
        }
        public void SendNotificationForUser(Guid UserId, string title, string message)
        {
            RecipientUserId = UserId;
            SendNotification(title, message);
        }
        public void SendNotificationForHospital(Guid HospitalId, string title, string message)
        {
            RecipientHospitalId = HospitalId;
            SendNotification(title, message);
        }
        public void SendNotificationForBloodBank(Guid BloodBankId, string title, string message)
        {
            RecipientBloodBankId = BloodBankId;
            SendNotification(title, message);
        }
        public void SendNotificationForBloodRequest(Guid BloodRequestId, string title, string message)
        {
            RelatedBloodRequestId = BloodRequestId;
            SendNotification(title, message);
        }
    }
}

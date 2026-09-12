using System;
using System.Collections.Generic;
using System.Text;

namespace Domain.Entities
{
    class clsAdmin: User
    {
        private short _Permissions { get; set; }

        public clsAdmin(short Permissions)
        {
            _Permissions = Permissions;
        }
        public void ViewFutureNeeds()
        {

        }

        public bool RequestBlood()
        {
            return false;
        }

        public void ViewRecord()
        {

        }

        public void ViewStorage()
        {

        }

        public void Login()
        {

        }

        public void Logout()
        {

        }
    }
}

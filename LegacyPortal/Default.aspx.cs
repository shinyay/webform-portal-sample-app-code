using System;
using System.Data;
using System.Globalization;
using LegacyPortal.Common;
using LegacyPortal.Data;

namespace LegacyPortal
{
    public partial class RequestList : PortalPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DataTable table = RequestData.GetRequests();
            int pending = 0;
            int approved = 0;
            int rejected = 0;
            foreach (DataRow row in table.Rows)
            {
                switch ((string)row["status"])
                {
                    case "pending": pending++; break;
                    case "approved": approved++; break;
                    case "rejected": rejected++; break;
                    default: throw new InvalidOperationException("Unknown request status.");
                }
            }
            TotalCount.Text = table.Rows.Count.ToString(CultureInfo.InvariantCulture);
            PendingCount.Text = pending.ToString(CultureInfo.InvariantCulture);
            ApprovedCount.Text = approved.ToString(CultureInfo.InvariantCulture);
            RejectedCount.Text = rejected.ToString(CultureInfo.InvariantCulture);
            EmptyMessage.Visible = table.Rows.Count == 0;
            Requests.DataSource = table;
            Requests.DataBind();
        }
    }
}

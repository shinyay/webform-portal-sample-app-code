using System;
using System.Data;
using System.Globalization;
using System.Web;
using LegacyPortal.Common;
using LegacyPortal.Data;

namespace LegacyPortal
{
    public partial class RequestDetail : PortalPage
    {
        private int id;

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            if (Request.HttpMethod == "POST")
            {
                bool approve = Request.Form[ApproveButton.UniqueID] != null;
                bool reject = Request.Form[RejectButton.UniqueID] != null;
                if (approve == reject)
                    throw new HttpException(400, "Exactly one decision action is required.");
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Int32.TryParse(Request.QueryString["id"], NumberStyles.None, CultureInfo.InvariantCulture, out id) || id <= 0)
                throw new HttpException(400, "A positive integer request id is required.");
            if (!IsPostBack)
                LoadRequest();
        }

        private void LoadRequest()
        {
            DataRow row = RequestData.GetRequest(id);
            if (row == null)
                throw new HttpException(404, "Request not found.");
            RequestId.Text = id.ToString(CultureInfo.InvariantCulture);
            RequestTitle.Text = (string)row["title"];
            Applicant.Text = (string)row["applicant"];
            Department.Text = PortalValues.DepartmentText((string)row["department"]);
            Kind.Text = PortalValues.KindText((string)row["kind"]);
            Status.Text = PortalValues.StatusText((string)row["status"]);
            CreatedAt.Text = PortalValues.JapanTime(row["created_at"]);
            Details.Text = (string)row["details"];
            bool pending = (string)row["status"] == "pending";
            DecisionPanel.Visible = pending;
            ProcessedMessage.Visible = !pending;
        }

        protected void ApproveButton_Click(object sender, EventArgs e)
        {
            ApplyDecision("approved");
        }

        protected void RejectButton_Click(object sender, EventArgs e)
        {
            ApplyDecision("rejected");
        }

        private void ApplyDecision(string status)
        {
            DecisionResult result = RequestData.Decide(id, status);
            if (result == DecisionResult.Missing)
                throw new HttpException(404, "Request not found.");
            if (result == DecisionResult.AlreadyProcessed)
                throw new HttpException(409, "Request was already processed.");
            Response.Redirect("RequestDetail.aspx?id=" + id.ToString(CultureInfo.InvariantCulture), false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}

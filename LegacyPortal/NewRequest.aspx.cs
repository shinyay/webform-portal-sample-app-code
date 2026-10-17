using System;
using System.Globalization;
using System.Web;
using System.Web.UI.WebControls;
using LegacyPortal.Common;
using LegacyPortal.Data;

namespace LegacyPortal
{
    public partial class NewRequest : PortalPage
    {
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            if (Request.HttpMethod == "POST")
            {
                string department = Request.Form[Department.UniqueID];
                string kind = Request.Form[Kind.UniqueID];
                if ((!String.IsNullOrEmpty(department) && !PortalValues.IsDepartment(department))
                    || (!String.IsNullOrEmpty(kind) && !PortalValues.IsKind(kind)))
                    throw new HttpException(400, "Invalid department or kind.");
                if (Request.Form[SaveButton.UniqueID] == null)
                    throw new HttpException(400, "A save action is required.");
            }
        }

        protected void Text_ServerValidate(object sender, ServerValidateEventArgs args)
        {
            CustomValidator validator = (CustomValidator)sender;
            string value;
            string error;
            int minimum = validator == DetailsValid ? 10 : 1;
            int maximum = validator == TitleValid ? 80 : validator == ApplicantValid ? 40 : 1000;
            args.IsValid = PortalValues.TryText(args.Value, minimum, maximum,
                validator == DetailsValid, out value, out error);
            validator.ErrorMessage = error;
        }

        protected void SaveButton_Click(object sender, EventArgs e)
        {
            Page.Validate("request");
            if (!Page.IsValid || !PortalValues.IsDepartment(Department.SelectedValue)
                || !PortalValues.IsKind(Kind.SelectedValue))
            {
                Response.StatusCode = 400;
                InputError.Text = "保存していません。入力欄のエラーを確認してください。";
                InputError.Visible = true;
                System.Diagnostics.Trace.TraceWarning("Invalid input on NewRequest.aspx; no request was saved.");
                return;
            }
            string title;
            string applicant;
            string details;
            string error;
            if (!PortalValues.TryText(RequestTitle.Text, 1, 80, false, out title, out error)
                || !PortalValues.TryText(Applicant.Text, 1, 40, false, out applicant, out error)
                || !PortalValues.TryText(Details.Text, 10, 1000, true, out details, out error))
                throw new HttpException(400, "Invalid request text.");
            int id = RequestData.CreateRequest(title, applicant, Department.SelectedValue, Kind.SelectedValue, details);
            Response.Redirect("RequestDetail.aspx?id=" + id.ToString(CultureInfo.InvariantCulture), false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}

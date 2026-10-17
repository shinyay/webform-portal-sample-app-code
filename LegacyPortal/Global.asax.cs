using System;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Globalization;
using System.Web;
using System.Web.UI;

namespace LegacyPortal
{
    public class PortalApplication : HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
            Trace.Listeners.Add(new TextWriterTraceListener(Server.MapPath("~/App_Data/portal.log"), "PortalLog"));
            Trace.AutoFlush = true;
        }

        protected void Application_Error(object sender, EventArgs e)
        {
            Exception error = Server.GetLastError();
            int status = 500;
            Exception current = error;
            while (current != null)
            {
                HttpException http = current as HttpException;
                if (http != null && http.GetHttpCode() != 500)
                    status = http.GetHttpCode();
                if (current is ViewStateException || current is HttpRequestValidationException)
                    status = 400;
                if (current is SqlException)
                    status = 503;
                current = current.InnerException;
            }

            Trace.TraceError("{0} HTTP {1} {2}: {3}",
                DateTime.UtcNow.ToString("s", CultureInfo.InvariantCulture), status, Request.Path, error);
            string message;
            switch (status)
            {
                case 400: message = "入力または送信内容が不正です。画面を開き直して確認してください。"; break;
                case 403: message = "この送信は受け付けられません。画面を開き直して操作してください。"; break;
                case 404: message = "指定された申請またはページは見つかりません。"; break;
                case 405: message = "この操作方法は利用できません。"; break;
                case 409: message = "この申請はすでに処理済みです。状態を再確認してください。"; break;
                case 503: message = "データベースを利用できません。保存成功とは扱わず、接続状態を確認してください。"; break;
                default: message = "処理中にエラーが発生しました。ログを確認してください。"; break;
            }
            Server.ClearError();
            Response.Clear();
            Response.StatusCode = status;
            Response.ContentType = "text/html; charset=utf-8";
            Response.Write("<!DOCTYPE html><html lang=\"ja\"><head><meta charset=\"utf-8\" />"
                + "<title>処理できませんでした</title></head><body><h1>処理できませんでした</h1><p>"
                + HttpUtility.HtmlEncode(message) + "</p><p>HTTP "
                + status.ToString(CultureInfo.InvariantCulture)
                + "</p><p><a href=\"Default.aspx\">申請一覧へ</a></p></body></html>");
            CompleteRequest();
        }

        protected void Application_End(object sender, EventArgs e)
        {
            Trace.Flush();
        }
    }
}

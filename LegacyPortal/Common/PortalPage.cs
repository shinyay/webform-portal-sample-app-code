using System;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI;

namespace LegacyPortal.Common
{
    public class PortalPage : Page
    {
        // .NET 2.0 has no IDisposable on this type; use one generator for the application lifetime.
        private static readonly RandomNumberGenerator SessionRandom = RandomNumberGenerator.Create();

        protected override void OnInit(EventArgs e)
        {
            if (!Request.IsLocal)
                throw new HttpException(403, "Local workshop access only.");
            if (Request.HttpMethod != "GET" && Request.HttpMethod != "HEAD" && Request.HttpMethod != "POST")
                throw new HttpException(405, "Unsupported request method.");

            string token = Session["PortalCsrf"] as string;
            if (token == null)
            {
                byte[] bytes = new byte[32];
                lock (SessionRandom)
                    SessionRandom.GetBytes(bytes);
                token = Convert.ToBase64String(bytes);
                Session["PortalCsrf"] = token;
            }
            ViewStateUserKey = token + "|" + Request.Path + "|" + Request.QueryString.ToString();
            if (Request.HttpMethod == "POST")
            {
                if (!SameToken(token, Request.Form["__PORTALCSRF"]))
                    throw new HttpException(403, "Missing, expired or invalid session token.");
                if (String.IsNullOrEmpty(Request.Form["__VIEWSTATE"])
                    || String.IsNullOrEmpty(Request.Form["__EVENTVALIDATION"])
                    || !String.IsNullOrEmpty(Request.Form["__EVENTTARGET"])
                    || !String.IsNullOrEmpty(Request.Form["__EVENTARGUMENT"]))
                    throw new HttpException(400, "Invalid postback state or target.");
            }
            ClientScript.RegisterHiddenField("__PORTALCSRF", token);
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoStore();
            Response.AppendHeader("X-Content-Type-Options", "nosniff");
            Response.AppendHeader("X-Frame-Options", "DENY");
            base.OnInit(e);
        }

        private static bool SameToken(string expected, string actual)
        {
            if (actual == null || actual.Length != expected.Length)
                return false;
            int difference = 0;
            for (int i = 0; i < expected.Length; i++)
                difference |= expected[i] ^ actual[i];
            return difference == 0;
        }
    }
}

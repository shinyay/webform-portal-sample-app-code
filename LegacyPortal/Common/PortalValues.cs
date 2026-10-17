using System;
using System.Globalization;
using System.Web;

namespace LegacyPortal.Common
{
    public static class PortalValues
    {
        public static bool TryText(string raw, int minimum, int maximum, bool multiline,
            out string value, out string error)
        {
            value = raw == null ? String.Empty : raw.Trim();
            error = String.Empty;
            string input = raw == null ? String.Empty : raw;
            for (int i = 0; i < input.Length; i++)
            {
                char character = input[i];
                if (Char.IsControl(character)
                    && !(multiline && (character == '\r' || character == '\n')))
                {
                    error = "制御文字は使用できません。内容欄のみ改行を使用できます。";
                    return false;
                }
                if (character >= '\uD800' && character <= '\uDBFF')
                {
                    if (i + 1 >= input.Length || input[i + 1] < '\uDC00' || input[i + 1] > '\uDFFF')
                    {
                        error = "不正なサロゲート文字は使用できません。";
                        return false;
                    }
                    i++;
                }
                else if (character >= '\uDC00' && character <= '\uDFFF')
                {
                    error = "不正なサロゲート文字は使用できません。";
                    return false;
                }
            }
            if (value.Length < minimum || value.Length > maximum)
            {
                error = minimum.ToString(CultureInfo.InvariantCulture) + "〜"
                    + maximum.ToString(CultureInfo.InvariantCulture)
                    + "文字で入力してください（UTF-16の単位数、前後の空白を除く）。";
                return false;
            }
            return true;
        }

        public static bool IsDepartment(string value)
        {
            return value == "engineering" || value == "sales" || value == "corporate" || value == "design";
        }

        public static bool IsKind(string value)
        {
            return value == "equipment" || value == "training" || value == "remote";
        }

        public static string DepartmentText(string value)
        {
            switch (value)
            {
                case "engineering": return "開発部";
                case "sales": return "営業部";
                case "corporate": return "管理部";
                case "design": return "デザイン部";
                default: throw new InvalidOperationException("Unknown department code.");
            }
        }

        public static string KindText(string value)
        {
            switch (value)
            {
                case "equipment": return "備品購入";
                case "training": return "研修参加";
                case "remote": return "在宅勤務";
                default: throw new InvalidOperationException("Unknown request kind.");
            }
        }

        public static string StatusText(string value)
        {
            switch (value)
            {
                case "pending": return "確認待ち";
                case "approved": return "承認済み";
                case "rejected": return "差し戻し";
                default: throw new InvalidOperationException("Unknown request status.");
            }
        }

        public static string Html(object value)
        {
            return HttpUtility.HtmlEncode(Convert.ToString(value, CultureInfo.InvariantCulture));
        }

        public static string JapanTime(object value)
        {
            DateTime utc = (DateTime)value;
            return utc.AddHours(9).ToString("yyyy/MM/dd HH:mm", CultureInfo.InvariantCulture) + " JST";
        }
    }
}

using System;

namespace YallaBaity.Areas.Api.Services
{
    public static class Extension
    {
        public static string DateToString(this DateTime? dateTime, string format)
        {
            if (dateTime == null)
            {
                return "";
            }
            else
            {
                return dateTime.Value.ToString(format);
            }
        }
    }
}

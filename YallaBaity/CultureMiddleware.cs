using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Localization.Routing;
using Microsoft.AspNetCore.Localization;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Extensions.Options;

namespace YallaBaity
{
    public class CultureMiddleware
    {
        private static readonly List<CultureInfo> _supportedCultures = new List<CultureInfo>
        {
           new CultureInfo("en"),
                    new CultureInfo("ar")
        };

        private static readonly RequestLocalizationOptions _localizationOptions = new RequestLocalizationOptions()
        {
            DefaultRequestCulture = new RequestCulture(culture: "ar", uiCulture: "ar"),
            SupportedCultures = _supportedCultures,
            SupportedUICultures = _supportedCultures,
            RequestCultureProviders = new List<IRequestCultureProvider>
                {
                    new QueryStringRequestCultureProvider() { QueryStringKey = "lang"},
                    new CookieRequestCultureProvider(),
                    new AcceptLanguageHeaderRequestCultureProvider() ,
                    new RouteDataRequestCultureProvider(),
                },
        };

        public void Configure(IApplicationBuilder app)
        {
            app.UseRequestLocalization(_localizationOptions);
        }

    }
}

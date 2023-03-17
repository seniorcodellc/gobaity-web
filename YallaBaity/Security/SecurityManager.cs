using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Security.Claims;
using YallaBaity.Areas.Api.ViewModel;
using YallaBaity.Models;


namespace YallaBaity.Security
{
    public class SecurityManager
    {
        async public void Signin(HttpContext context, DashBoardUser dashBoardUser, List<VwPagesGroupPermission> groupPermissions)
        {
            List<Claim> claims = new List<Claim>();
            claims.Add(new Claim(ClaimTypes.Name, dashBoardUser.UserName));
            claims.Add(new Claim(ClaimTypes.Email, dashBoardUser.Email));

            foreach (var item in groupPermissions)
            {
                claims.Add(new Claim(ClaimTypes.Role, item.PageKey));
            }

            ClaimsIdentity claimsIdentity = new ClaimsIdentity(claims, "DashBoardAuth");
            ClaimsPrincipal principal = new ClaimsPrincipal(claimsIdentity);
            await context.SignInAsync("DashBoardAuth", principal);
        }

        async public void SideSignin(HttpContext context,User user)
        {

            List<Claim> claims = new List<Claim>();
            claims.Add(new Claim(ClaimTypes.Name, user.UserName)); 
            claims.Add(new Claim("userId", user.UserId.ToString()));
            claims.Add(new Claim("isProvider", user.IsProvider.ToString()));


            ClaimsIdentity claimsIdentity = new ClaimsIdentity(claims, "SideAuth");
            ClaimsPrincipal principal = new ClaimsPrincipal(claimsIdentity);
            await context.SignInAsync("SideAuth", principal); 
        }

        async public void SignOut(HttpContext context,string scheme)
        {
            await context.SignOutAsync(scheme);
        }
    }
}

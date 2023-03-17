using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Linq.Dynamic.Core;
using YallaBaity.Areas.Api.Dto;
using YallaBaity.Areas.Api.Repository;
using YallaBaity.Areas.Api.Services;
using YallaBaity.Areas.Api.ViewModel;
using YallaBaity.Models;
using YallaBaity.Resources;
using YallaBaity.Security;

namespace YallaBaity.Areas.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    //[Authorize(Roles = "users")]
    public class DashBoardUsersController : ControllerBase
    {
        CryptServices _cryptServices;
        IBaseRepository<DashBoardUser> _dashboardUser;
        IBaseRepository<VwDashBoardUser> _vwDashboardUser;
        IBaseRepository<VwPagesGroupPermission> _vwPagesGroupPermission;
        ILinqServices _linqServices;
        IMapper _mapper;
        public DashBoardUsersController(IBaseRepository<DashBoardUser> dashboardUser, IBaseRepository<VwDashBoardUser> vwDashboardUser, IBaseRepository<VwPagesGroupPermission> vwPagesGroupPermission, ILinqServices linqServices, IMapper mapper)
        {
            _dashboardUser = dashboardUser;
            _vwDashboardUser = vwDashboardUser;
            _vwPagesGroupPermission = vwPagesGroupPermission;
            _linqServices = linqServices;
            _mapper = mapper;
            _cryptServices = new CryptServices();
        }

        [HttpGet("{id}")]
        public IActionResult GET(int id)
        {
            CryptServices crypt = new CryptServices();

            var user = _dashboardUser.GetById(id);
            user.Password = crypt.Decrypt(user.Password);

            return Ok(new DtoResponseModel() { State = true, Message = "", Data = user });
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            try
            {
                _dashboardUser.Remove(id);
                _dashboardUser.Save();
                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = new { } });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbThisRecordIsLinkedToOtherRecords, Data = new { } });
            }
        }

        [HttpPut("[action]/{id}")]
        public IActionResult Active(int id)
        {
            try
            {
                var dashBoardUser = _dashboardUser.GetById(id);
                dashBoardUser.IsActive = !dashBoardUser.IsActive;

                _dashboardUser.Update(dashBoardUser);
                _dashboardUser.Save();
                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = dashBoardUser.IsActive });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbThisRecordIsLinkedToOtherRecords, Data = new { } });
            }
        }

        [HttpPost]
        public IActionResult POST(DtoDashBoardUser model)
        {
            try
            { 
                var dashBoardUser = _mapper.Map<DashBoardUser>(model);
                dashBoardUser.Password = _cryptServices.Encrypt(model.Password);

                _dashboardUser.Add(dashBoardUser);
                _dashboardUser.Save();
                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = new { } });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpPut("{userId}")]
        public IActionResult PUT(int userId, DtoDashBoardUser model)
        {
            try
            {
                DashBoardUser dashBoardUser = _dashboardUser.GetById(userId);
                dashBoardUser.Password = _cryptServices.Encrypt(model.Password);
                dashBoardUser.UserName = model.UserName;
                dashBoardUser.Password = model.Password;
                dashBoardUser.Email = model.Email;
                dashBoardUser.GroupId = model.GroupId;
                dashBoardUser.IsActive = model.IsActive;

                _dashboardUser.Update(dashBoardUser);
                _dashboardUser.Save();
                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = new { } });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpPost("[action]")]
        public IActionResult LoadDataTable([FromForm] VmDataTable vmDataTable)
        {
            int totalResultsCount = _vwDashboardUser.Count();
            int filteredResultsCount = 0;
            var query = _linqServices.GenerateQuery<DashBoardUser>("UserId,UserName,Password,Email,GroupId");

            IQueryable<VwDashBoardUser> source;

            if (!string.IsNullOrEmpty(vmDataTable.search.value))
            {
                source = _vwDashboardUser.GetAll((" " + vmDataTable.columns[vmDataTable.order[0].column].name + " " + vmDataTable.order[0].dir), query, vmDataTable.search.value).Skip(vmDataTable.start).Take(vmDataTable.length);
                filteredResultsCount = _vwDashboardUser.Count(query, vmDataTable.search.value);
            }
            else
            {
                source = _vwDashboardUser.GetAll().OrderBy(" " + vmDataTable.columns[vmDataTable.order[0].column].name + " " + vmDataTable.order[0].dir).Skip(vmDataTable.start).Take(vmDataTable.length);
                filteredResultsCount = totalResultsCount;
            }

            return Ok(new
            {
                data = source,
                draw = vmDataTable.draw,
                recordsTotal = totalResultsCount,
                recordsFiltered = filteredResultsCount
            });
        }

        [HttpGet("[action]")]
        public bool HasName(string userName)
        {
            return _dashboardUser.Any(x => x.UserName == userName);
        }

        [HttpGet("[action]")]
        public bool HasEmail(string email)
        {
            return _dashboardUser.Any(x => x.Email == email);
        }

        [HttpPost("[action]"), AllowAnonymous]
        public IActionResult Login(DtoDashBoardLogin model)
        {
            IEnumerable<DashBoardUser> dashBoardUsers = _dashboardUser.GetAll(x => x.UserName == model.UserName);
            if (dashBoardUsers.Count() > 0)
            {
                DashBoardUser dashBoardUser = dashBoardUsers.FirstOrDefault();
                if (!dashBoardUser.IsActive)
                {
                    return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbThisAccountIsInactive, Data = new { } });
                }
                else if (!_cryptServices.Verify(model.Password, dashBoardUser.Password))
                {
                    return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbThePasswordIsIncorrect, Data = new { } });
                }
                else
                {
                    SecurityManager securityManager = new SecurityManager();
                    securityManager.Signin(this.HttpContext, dashBoardUser, _vwPagesGroupPermission.GetAll(x => x.GroupId == dashBoardUser.GroupId).ToList());

                    return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbWelcome + " " + dashBoardUser.UserName, Data = dashBoardUser });
                }
            }
            else
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbIncorrectUsername, Data = new { } });
            }
        }
    }
}

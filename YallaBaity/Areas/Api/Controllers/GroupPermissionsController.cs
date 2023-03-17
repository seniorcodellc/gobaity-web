using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections;
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

namespace YallaBaity.Areas.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    //[Authorize(Roles = "group_permissions")]
    public class GroupPermissionsController : ControllerBase
    {
        IBaseRepository<GroupPermission> _groupPermission; 
        ILinqServices _linqServices;
        IProcedureServices _procedureServices;
        public GroupPermissionsController(IBaseRepository<GroupPermission> groupPermission,  ILinqServices linqServices, IProcedureServices procedureServices)
        {
            _groupPermission = groupPermission; 
            _linqServices = linqServices;
            _procedureServices = procedureServices;
        }
         
        [HttpPost("{PageId}/{GroupId}")] 
        public IActionResult TogglePermission(int PageId, int GroupId)
        {
            if (_groupPermission.Any(x => x.PageId == PageId && x.GroupId == GroupId))
            {
                _groupPermission.Remove(_groupPermission.Find(x => x.PageId == PageId && x.GroupId == GroupId));
            }
            else
            {
                GroupPermission groupPermission = new GroupPermission();
                groupPermission.PageId = PageId;
                groupPermission.GroupId = GroupId;
                _groupPermission.Add(groupPermission);
            }

            _groupPermission.Save();
            return Ok(new DtoResponseModel(){ State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = new { } });
        }

        [HttpPost("[action]/{GroupId}/{TabId}")]
        public IActionResult LoadDataTable([FromForm] VmDataTable vmDataTable,int GroupId, int TabId)
        { 
            IQueryable<VmGroupPermissions> groupPermissions = _procedureServices.RawSqlQuery($"[Auth].[LoadGroupPermissions] {GroupId},{TabId}", x => new VmGroupPermissions() { PageAname = x["PageAname"].ToString(), PageEname = x["PageEname"].ToString(), PageId = x["PageId"].ToString(), State = x["State"].ToString() }).AsQueryable();
            IQueryable<VmGroupPermissions> source;

            int totalResultsCount = groupPermissions.Count();
            int filteredResultsCount = 0;
            var query = _linqServices.GenerateQuery<PagesTab>("PageId,PageAname,PageEname,State");
             

            if (!string.IsNullOrEmpty(vmDataTable.search.value))
            {
                source = groupPermissions.OrderBy(" " + vmDataTable.columns[vmDataTable.order[0].column].name + " " + vmDataTable.order[0].dir).Where(query, vmDataTable.search.value).Skip(vmDataTable.start).Take(vmDataTable.length);
                filteredResultsCount = groupPermissions.Where(query, vmDataTable.search.value).Count();
            }
            else
            {
                source = groupPermissions.OrderBy(" " + vmDataTable.columns[vmDataTable.order[0].column].name + " " + vmDataTable.order[0].dir).Skip(vmDataTable.start).Take(vmDataTable.length);
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
    }
}

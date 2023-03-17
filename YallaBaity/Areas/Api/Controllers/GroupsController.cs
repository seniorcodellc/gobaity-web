using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
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
    //[Authorize(Roles = "groups")]
    public class GroupsController : Controller
    {
        IBaseRepository<Group> _group;
        IBaseRepository<VwGroup> _vwGroup;
        ILinqServices _linqServices;
        public GroupsController(IBaseRepository<Group> group, IBaseRepository<VwGroup> vwGroup, ILinqServices linqServices)
        {
            _group = group;
            _vwGroup = vwGroup;
            _linqServices = linqServices;
        }

        [HttpGet]
        public IActionResult GET()
        {
            var groups = _group.GetAll(x => x.IsActive == true);
            return Ok(new DtoResponseModel() { State = true, Message = "", Data = groups });
        }

        [HttpGet("{id}")]
        public IActionResult GET(int id)
        {
            var group = _group.GetById(id);
            return Ok(new DtoResponseModel() { State = true, Message = "", Data = group });
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            try
            {
                _group.Remove(id);
                _group.Save();
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
                var groups = _group.GetById(id);
                groups.IsActive = !groups.IsActive;

                _group.Update(groups);
                _group.Save();
                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = groups.IsActive });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbThisRecordIsLinkedToOtherRecords, Data = new { } });
            }
        }

        [HttpPost]
        public IActionResult POST(DtoGroups model)
        {
            var group = new Group()
            {
                GroupAname = model.GroupAname,
                GroupEname = model.GroupEname,
                IsActive = model.IsActive,
            };

            _group.Add(group);
            _group.Save();
            return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = new { } });
        }

        [HttpPut("{groupId}")]
        public IActionResult PUT(int groupId, DtoGroups model)
        {
            var group = _group.GetById(groupId);
            group.GroupEname = model.GroupEname;
            group.GroupAname = model.GroupAname;
            group.IsActive = model.IsActive;

            _group.Update(group);
            _group.Save();
            return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = new { } });
        }

        [HttpPost("[action]")]
        public IActionResult LoadDataTable([FromForm] VmDataTable vmDataTable)
        {
            int totalResultsCount = _group.Count();
            int filteredResultsCount = 0;
            var query = _linqServices.GenerateQuery<VwGroup>("GroupId,GroupAname,GroupEname");

            IQueryable<VwGroup> source;

            if (!string.IsNullOrEmpty(vmDataTable.search.value))
            {
                source = _vwGroup.GetAll((" " + vmDataTable.columns[vmDataTable.order[0].column].name + " " + vmDataTable.order[0].dir), query, vmDataTable.search.value).Skip(vmDataTable.start).Take(vmDataTable.length);
                filteredResultsCount = _vwGroup.Count(query, vmDataTable.search.value);
            }
            else
            {
                source = _vwGroup.GetAll().OrderBy(" " + vmDataTable.columns[vmDataTable.order[0].column].name + " " + vmDataTable.order[0].dir).Skip(vmDataTable.start).Take(vmDataTable.length);
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

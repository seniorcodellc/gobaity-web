using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Linq.Dynamic.Core;
using System.Net;
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
    public class SizesController : ControllerBase
    {
        ILinqServices _linqServices;
        IBaseRepository<Size> _size;
        IBaseRepository<VwSize> _vwSize;
        IMapper _mapper;
        public SizesController(IBaseRepository<Size> size, IBaseRepository<VwSize> vwSize, ILinqServices linqServices, IMapper mapper)
        {
            _vwSize = vwSize;
            _size = size;
            _linqServices = linqServices;
            _mapper = mapper;
        }

        [HttpGet]
        public IActionResult GET()
        {
            string lang = CultureInfo.CurrentCulture.Name;
            var sizes = _size.GetAll(x => x.IsActive == true && x.IsDelete == false);
            return Ok(new DtoResponseModel()
            {
                State = true,
                Message = "",
                Data = _mapper.Map<List<DtoSizesQueary>>(sizes, opt => { opt.Items["culture"] = lang; })
            });
        }

        [HttpGet("{id}")]
        public IActionResult GET(int id)
        {
            var size = _size.GetById(id);
            return Ok(new DtoResponseModel() { State = true, Message = "", Data = size });
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            try
            {
                Size size = _size.GetById(id);
                size.IsDelete = true;

                _size.Update(size);
                _size.Save();
                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = new { } });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpPut("[action]/{id}")]
        public IActionResult Active(int id)
        {
            try
            {
                var size = _size.GetById(id);
                size.IsActive = !size.IsActive;

                _size.Update(size);
                _size.Save();
                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = size.IsActive });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpPost]
        public IActionResult POST(DtoSizes model)
        {
            try
            {
                var size = new Size()
                {
                    SizeAname = model.SizeAname,
                    SizeEname = model.SizeEname,
                    IsActive = model.IsActive,
                };

                _size.Add(size);
                _size.Save();
                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = new { } });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpPut("{sizeId}")]
        public IActionResult PUT(int sizeId, DtoSizes model)
        {
            try
            {
                var size = _size.GetById(sizeId);
                size.SizeAname = model.SizeAname;
                size.SizeEname = model.SizeEname;
                size.IsActive = model.IsActive;

                _size.Update(size);
                _size.Save();
                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = new { } });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel()
                {
                    State = false,
                    Message = AppResource.lbError,
                    Data = new { }
                });
            }
        }

        [HttpPost("[action]")]
        public IActionResult LoadDataTable([FromForm] VmDataTable vmDataTable)
        {
            int totalResultsCount = _size.Count(x => x.IsDelete == false);
            int filteredResultsCount = 0;
            var query = _linqServices.GenerateQuery<VwSize>("SizeId,SizeName");

            IQueryable<VwSize> source;

            if (!string.IsNullOrEmpty(vmDataTable.search.value))
            {
                source = _vwSize.GetAll(" " + vmDataTable.columns[vmDataTable.order[0].column].name + " " + vmDataTable.order[0].dir, (query + "and IsDelete=@1"), vmDataTable.search.value, false).Skip(vmDataTable.start).Take(vmDataTable.length);
                filteredResultsCount = _size.Count((query + "and IsDelete=@1"), vmDataTable.search.value, false);
            }
            else
            {
                source = _vwSize.GetAll(" " + vmDataTable.columns[vmDataTable.order[0].column].name + " " + vmDataTable.order[0].dir, x => x.IsDelete == false).Skip(vmDataTable.start).Take(vmDataTable.length);
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

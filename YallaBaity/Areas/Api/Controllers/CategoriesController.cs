using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Linq.Dynamic.Core;
using System.Text.RegularExpressions;
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
    public class CategoriesController : ControllerBase
    {
        ILinqServices _linqServices;
        IBaseRepository<Category> _categories;
        IBaseRepository<VwCategory> _vwCategories;
        IBaseRepository<VwFoodCategory> _vwFoodCategories;
        IFilesServices _filesServices;
        IMapper _mapper;
        public CategoriesController(IBaseRepository<Category> categories,IBaseRepository<VwCategory> vwCategories,ILinqServices linqServices,IBaseRepository<VwFoodCategory> vwFoodCategories,IFilesServices filesServices, IMapper mapper)
        {
            _linqServices = linqServices;
            _categories = categories;
            _vwCategories = vwCategories;
            _vwFoodCategories = vwFoodCategories;
            _filesServices = filesServices;
            _mapper = mapper;
        }

        [HttpGet]
        public IActionResult GET()
        {
            try
            { 
                string lang = CultureInfo.CurrentCulture.Name;

                var categories = _categories.GetAll(x => x.IsActive == true && x.IsDelete == false);
                return Ok(new DtoResponseModel()
                {
                    State = true,
                    Message = "",
                    Data = _mapper.Map<List<DtoCategories>>(categories, opt => { opt.Items["culture"] = lang; })
                });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpGet("{id}")]
        public IActionResult GET(int id)
        {
            try
            {
                VwCategory vwCategory = _vwCategories.Find(x => x.CategoryId == id);
                return Ok(new DtoResponseModel() { State = true, Message = "", Data = vwCategory });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }
         
        [HttpGet("[action]/{userId}")]
        public IActionResult GetUsedByProvider(int userId)
        {
            try
            {
                string lang = CultureInfo.CurrentCulture.Name;

                var lstCategories=  _vwFoodCategories.GetAll(x=>x.UserId==userId).Select(x => x.CategoryId);
                var categories= _categories.GetAll(x => lstCategories.Contains(x.CategoryId)); 

                return Ok(new DtoResponseModel() { State = true, Message = "", Data = _mapper.Map<List<DtoCategories>>(categories, opt => { opt.Items["culture"] = lang; }) });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            try
            {
                Category category = _categories.GetById(id);
                category.IsDelete = true;

                _categories.Update(category);
                _categories.Save();
                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = new { } });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpPost]
        public IActionResult POST([FromForm] DtoCategoriesForm model)
        {
            try
            {
                string lang = CultureInfo.CurrentCulture.Name;
                Category category = _mapper.Map<Category>(model, opt => { opt.Items["culture"] = lang; });
                category.ImagePath = "/Uploads/Categorys/" + _filesServices.GetRandomFileName() + ".webp";

                _categories.Add(category);
                _categories.Save();

                _filesServices.SaveImage(category.ImagePath, model.Image.OpenReadStream());
                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = new { } });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpPut("{categoryId}")]
        public IActionResult PUT(int categoryId, [FromForm] DtoCategoriesForm model)
        {
            try
            {
                string oldImage = string.Empty;

                Category category = _categories.GetById(categoryId);
                category.CategoryEname = model.CategoryEname;
                category.CategoryAname = model.CategoryAname;
                category.CategoryAdescription = model.CategoryAdescription;
                category.CategoryEdescription = model.CategoryEdescription;
                category.BackgroundColor = model.BackgroundColor;
                category.IsActive = model.IsActive;

                if (model.Image != null)
                {
                    oldImage = category.ImagePath;
                    category.ImagePath = "/Uploads/Categorys/" + Guid.NewGuid() + ".webp";
                }

                _categories.Update(category);
                _categories.Save();

                if (model.Image != null)
                {
                    _filesServices.DeleteFile(oldImage);
                    _filesServices.SaveImage(category.ImagePath, model.Image.OpenReadStream());
                }

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
                Category category = _categories.GetById(id);
                category.IsActive = !category.IsActive;

                _categories.Update(category);
                _categories.Save();
                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = category.IsActive });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbThisRecordIsLinkedToOtherRecords, Data = new { } });
            }
        }

        [HttpPost("[action]")]
        public IActionResult LoadDataTable([FromForm] VmDataTable vmDataTable)
        {
            int totalResultsCount = _categories.Count(x => x.IsDelete == false);
            int filteredResultsCount = 0;
            var query = _linqServices.GenerateQuery<VwCategory>("CategoryId,CategoryAname,CategoryEname");

            IQueryable<VwCategory> source;

            if (!string.IsNullOrEmpty(vmDataTable.search.value))
            {
                source = _vwCategories.GetAll((" " + vmDataTable.columns[vmDataTable.order[0].column].name + " " + vmDataTable.order[0].dir), (query + "and IsDelete=@1"), vmDataTable.search.value, false).Skip(vmDataTable.start).Take(vmDataTable.length);
                filteredResultsCount = _vwCategories.Count((query + "and IsDelete=@1"), vmDataTable.search.value, false);
            }
            else
            {
                source = _vwCategories.GetAll((" " + vmDataTable.columns[vmDataTable.order[0].column].name + " " + vmDataTable.order[0].dir), x => x.IsDelete == false).Skip(vmDataTable.start).Take(vmDataTable.length);
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

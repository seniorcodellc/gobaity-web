using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Globalization;
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
    //[Authorize(AuthenticationSchemes = "BasicAuthentication")]
    public class FoodsController : ControllerBase
    {
        IMapper _mapper;
        ILinqServices _linqServices;
        IUnitOfWork _unitOfWork;
        FoodServices _foodServices;
        public FoodsController(ILinqServices linqServices, IUnitOfWork unitOfWork, IFilesServices filesServices, IProcedureServices procedureServices, IMapper mapper)
        {
            _mapper = mapper;
            _unitOfWork = unitOfWork;
            _linqServices = linqServices;
            _foodServices = new FoodServices(filesServices, procedureServices);
        }

        //price,rate,mostPopular,mostWatched,preparationTime
        [HttpGet]
        public IActionResult GET([FromQuery] DtoFoodSearch search)
        {
            try
            {
                var items = _unitOfWork.VwFoods.FromSqlRaw(_foodServices.PrepairSqlQueary(search))
                    .OrderBy(_foodServices.PrepairOrder(search.order))
                    .Skip(search.page * search.size).Take(search.size);

                return Ok(new DtoResponseModel()
                {
                    State = true,
                    Message = "",
                    Data = items
                });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpGet("[action]")]
        public IActionResult HomePage([FromQuery] DtoFoodSearch search)
        {
            try
            { 
                string lang = CultureInfo.CurrentCulture.Name;
                var categorys = _mapper.Map<List<DtoCategories>>(_unitOfWork.Categories.GetAll(x => x.IsActive == true && x.IsDelete == false), opt => { opt.Items["culture"] = lang; });
                var ads = _unitOfWork.Ads.GetAll(x => x.IsActive == true);

                var mostPopular = _unitOfWork.VwFoods.FromSqlRaw(_foodServices.PrepairSqlQueary(search), search.foodName).OrderBy(_foodServices.PrepairOrder("mostPopular")).Skip(search.page * search.size).Take(search.size);
                var mostWatched = _unitOfWork.VwFoods.FromSqlRaw(_foodServices.PrepairSqlQueary(search), search.foodName).OrderBy(_foodServices.PrepairOrder("mostWatched")).Skip(search.page * search.size).Take(search.size);
                object lastSeen;

                if (search.userId == -1)
                {
                    lastSeen = new { };
                }
                else
                {
                    lastSeen = _unitOfWork.VwFoods.FromSqlRaw(_foodServices.PrepairSqlQueary(search," and " + $"food.VwFood.FoodId in(select FoodId from  [user].UsersViews where [user].UsersViews.[UserId]={search.userId}) "), search.foodName).OrderBy(_foodServices.PrepairOrder(string.Empty)).Skip(search.page * search.size).Take(search.size);
                }

                return Ok(new
                {
                    State = true,
                    message = "",
                    Data = new
                    {
                        categories = categorys,
                        ads = ads,
                        lastSeen = lastSeen,
                        mostPopulars = mostPopular,
                        mostWatcheds = mostWatched,
                    }
                });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpGet("[action]")]
        public IActionResult LastSeen([FromQuery] DtoFoodSearch search)
        {
            try
            {
                var items = _unitOfWork.VwFoods.FromSqlRaw(_foodServices.PrepairSqlQueary(search, " and " + $"food.VwFood.FoodId in(select FoodId from  [user].UsersViews where [user].UsersViews.[UserId]={search.userId})  "), search.foodName).OrderBy(_foodServices.PrepairOrder(search.order)).Skip(search.page * search.size).Take(search.size);

                return Ok(new { State = true, message = "", Data = items });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpGet("[action]")]
        public IActionResult Provider([FromQuery] int providerId, [FromQuery] DtoFoodSearch search)
        {
            try
            {
                var items = _unitOfWork.VwFoods.FromSqlRaw(_foodServices.PrepairSqlQueary(search, " and " + $"UserId={providerId} "), search.foodName).OrderBy(_foodServices.PrepairOrder(search.order)).Skip(search.page * search.size).Take(search.size).ToList();
                var groups = items.Select(c => c.Date).DistinctBy(c => c).ToList();
                var groupedItems = new Dictionary<string, List<VwFood>>();
                foreach(var item in groups)
                {
                    if (!groupedItems.ContainsKey(item))
                    {
                        groupedItems.Add(item, items.Where(c => c.Date == item).ToList());
                    }
                }
                return Ok(new DtoResponseModel() { State = true, Message = "", Data = groupedItems });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }
       
        [HttpGet("[action]")]
        public IActionResult Pending([FromQuery] DtoFoodSearch search)
        {
            try
            {
                var items = _unitOfWork.VwFoods.FromSqlRaw(_foodServices.PrepairSqlQueary(search)).OrderBy(_foodServices.PrepairOrder(search.order)).Skip(search.page * search.size).Take(search.size);

                return Ok(new DtoResponseModel()
                {
                    State = true,
                    Message = "",
                    Data = items
                });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }
        [HttpGet("[action]")]
        public IActionResult Favorites([FromQuery] DtoFoodSearch search)
        {
            try
            {
                var items = _unitOfWork.VwFoods.FromSqlRaw(_foodServices.PrepairSqlQueary(search)).Where(x=>x.IsFavorited==true).OrderBy(_foodServices.PrepairOrder(search.order)).Skip(search.page * search.size).Take(search.size);

                return Ok(new DtoResponseModel()
                {
                    State = true,
                    Message = "",
                    Data = items
                });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpPost("[action]")]
        public IActionResult LoadDataTable([FromForm] VmDataTable vmDataTable, bool isPending)
        {
            int totalResultsCount = _unitOfWork.VwFoods.Count(x => x.IsApproved == !isPending);
            int filteredResultsCount = 0;
            var query = _linqServices.GenerateQuery<VwFood>("FoodId,FoodName,Description,Price,UserName,CategoryAname,CategoryEname", " and IsApproved=@1");

            IQueryable<VwFood> source;

            if (!string.IsNullOrEmpty(vmDataTable.search.value))
            {
                source = _unitOfWork.VwFoods.GetAll(" " + vmDataTable.columns[vmDataTable.order[0].column].name + " " + vmDataTable.order[0].dir, query, vmDataTable.search.value, !isPending).Skip(vmDataTable.start).Take(vmDataTable.length);
                filteredResultsCount = _unitOfWork.VwFoods.Count(query, vmDataTable.search.value, !isPending);
            }
            else
            {
                source = _unitOfWork.VwFoods.GetAll(x => x.IsApproved == !isPending).OrderBy(" " + vmDataTable.columns[vmDataTable.order[0].column].name + " " + vmDataTable.order[0].dir).Skip(vmDataTable.start).Take(vmDataTable.length);
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

        [HttpGet("{id}")]
        public IActionResult GET(int id)
        {
            try
            {
                string lang = CultureInfo.CurrentCulture.Name;

                var categories = _unitOfWork.Categories.FromSqlRaw($"select * from food.Categories " +
                    $"where IsDelete='False' and IsActive='True' and " +
                    $"food.Categories.CategoryId in(select CategoryId " +
                    $"from food.FoodCategories where FoodId={id})");
                var food = _unitOfWork.VwFoods.Find(x => x.FoodId == id);

                return Ok(new DtoResponseModel()
                {
                    State = true,
                    Message = "",
                    Data = new
                    {
                        Sizes = _mapper.Map<List<DtoFoodsSizes>>(_unitOfWork.VwFoodsSizes.GetAll(x => x.FoodId == id), opt => { opt.Items["culture"] = lang; }),
                        Food = food,
                        Images = _unitOfWork.FoodsImages.GetAll(x => x.FoodId == id),
                        Categories = _mapper.Map<List<DtoCategories>>(categories, opt => { opt.Items["culture"] = lang; }),
                        Reviews = _unitOfWork.VwUserRatings.GetAll(x => x.FoodId == id).OrderByDescending(x => x.UserRatingId).Take(30),
                        OtherByUser = _unitOfWork.VwFoods.GetAll(x => x.UserId == food.UserId && x.FoodId != food.FoodId && x.IsApproved == true && x.IsActive == true)
                        //  SimilarFoods = _unitOfWork.VwFoods.SqlCondition($"FoodId in(select FoodId from food.FoodCategories where food.FoodCategories.CategoryId in(select CategoryId from food.FoodCategories where FoodId ={id})) and IsApproved='True'").OrderByDescending(x => x.FoodId).Take(30),
                    }
                });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpPost]
        public IActionResult POST([FromForm] DtoFood vmModel)
        {
            try
            {
                Food model = new Food
                {
                    FoodId = _unitOfWork.Foods.NewId(x => x.FoodId),
                    Description = vmModel.Description,
                    IsActive = true,
                    UserId = vmModel.UserId,
                    Price = vmModel.Price,
                    FoodName = vmModel.FoodName,
                    CreationDate = DateTime.Now,
                    IsApproved = true,
                    PreparationTime = vmModel.PreparationTime,
                };

                _unitOfWork.Foods.Add(model);
                _unitOfWork.Save();

                List<FoodsImage> foodsImages = _foodServices.FillFoodsImages(vmModel.images, model.FoodId, false);
                List<FoodsSize> foodsSizes = _foodServices.FillFoodsSizes(vmModel.Sizes, model.FoodId);
                List<FoodCategory> foodCategories = _foodServices.FillFoodsCategories(vmModel.Categories, model.FoodId);


                if (foodsImages.Count() > 0)
                    _unitOfWork.FoodsImages.AddRange(foodsImages);
                if (foodsSizes.Count() > 0)
                    _unitOfWork.FoodsSizes.AddRange(foodsSizes);
                if (foodCategories.Count() > 0)
                    _unitOfWork.FoodCategories.AddRange(foodCategories);

                _unitOfWork.Save();


                model.FoodCategories = null;
                model.FoodsSizes = null;
                model.FoodsImages = null;


                return Ok(new DtoResponseModel()
                {
                    State = true,
                    Message = AppResource.lbTheOperationWasCompletedSuccessfully,
                    Data = new { Model = model, FoodsImages = foodsImages.Select(x => x.ImagePath) },
                });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpPut("{foodId}")]
        public IActionResult PUT(int foodId, [FromForm] DtoFood vmModel)
        {
            try
            {
                Food model = _unitOfWork.Foods.GetById(foodId);
                model.Description = vmModel.Description;
                model.Price = vmModel.Price;
                model.FoodName = vmModel.FoodName;
                model.PreparationTime = vmModel.PreparationTime;

                _unitOfWork.Foods.Update(model);
                _unitOfWork.Save();

                _unitOfWork.FoodsImages.RemoveRange(_unitOfWork.FoodsImages.GetAll(x => x.FoodId == model.FoodId));
                _unitOfWork.FoodsSizes.RemoveRange(_unitOfWork.FoodsSizes.GetAll(x => x.FoodId == model.FoodId));
                _unitOfWork.FoodCategories.RemoveRange(_unitOfWork.FoodCategories.GetAll(x => x.FoodId == model.FoodId));
                _unitOfWork.Save();

                List<FoodsImage> foodsImages = _foodServices.FillFoodsImages(vmModel.images, model.FoodId, true);
                List<FoodsSize> foodsSizes = _foodServices.FillFoodsSizes(vmModel.Sizes, model.FoodId);
                List<FoodCategory> foodCategories = _foodServices.FillFoodsCategories(vmModel.Categories, model.FoodId);

                if (foodsImages.Count() > 0)
                    _unitOfWork.FoodsImages.AddRange(foodsImages);
                if (foodsSizes.Count() > 0)
                    _unitOfWork.FoodsSizes.AddRange(foodsSizes);
                if (foodCategories.Count() > 0)
                    _unitOfWork.FoodCategories.AddRange(foodCategories);
                _unitOfWork.Save();

                model.FoodCategories = null;
                model.FoodsSizes = null;
                model.FoodsImages = null;

                return Ok(new DtoResponseModel()
                {
                    State = true,
                    Message = AppResource.lbTheOperationWasCompletedSuccessfully,
                    Data = new { Model = model, FoodsImages = foodsImages.Select(x => x.ImagePath) },
                });
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
                var food = _unitOfWork.Foods.GetById(id);
                food.IsDelete = true;

                _unitOfWork.Foods.Update(food);
                _unitOfWork.Save();
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
                var food = _unitOfWork.Foods.GetById(id);
                food.IsActive = !food.IsActive;

                _unitOfWork.Foods.Update(food);
                _unitOfWork.Save();
                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = food.IsActive });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpGet("{foodId}/Rating")]
        public IActionResult GET(int foodId, int page = 0, int size = 30)
        {
            try
            {
                var items = _unitOfWork.VwUserRatings.GetAll(x => x.FoodId == foodId).OrderByDescending(x => x.UserRatingId).Skip(page * size).Take(size);
                return Ok(new DtoResponseModel() { State = true, Message = "", Data = items });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbThisRecordIsLinkedToOtherRecords, Data = new { } });
            }
        }
    }
}

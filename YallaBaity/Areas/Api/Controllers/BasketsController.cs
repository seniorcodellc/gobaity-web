using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Globalization;
using System.Linq;
using YallaBaity.Areas.Api.Dto;
using YallaBaity.Areas.Api.Repository;
using YallaBaity.Areas.Api.ViewModel;
using YallaBaity.Models;
using YallaBaity.Resources;

namespace YallaBaity.Areas.Api.Controllers
{
    [Route("api/Users")]
    [ApiController]
    public class BasketsController : Controller
    {
        IMapper _mapper;
        IBaseRepository<Basket> _basket;
        IBaseRepository<BasketSize> _basketSize;
        IBaseRepository<VwBasket> _vwBasket;
        IBaseRepository<Food> _food;
        public BasketsController(IBaseRepository<Basket> basket, IBaseRepository<VwBasket> vwBasket, IBaseRepository<BasketSize> basketSize, IMapper mapper,
           IBaseRepository<Food> food)
        {
            _basket = basket;
            _vwBasket = vwBasket;
            _mapper = mapper;
            _basketSize = basketSize;
            _food = food;
        }

        [HttpPost("{userId}/[controller]")]
        public IActionResult POST(int userId, DtoBasket model)
        {
            try
            {
                var user_basket_items = new List<Basket>();
                user_basket_items = _basket.GetAll(c => c.UserId == userId && _food.GetElement(c.FoodId).UserId != _food.GetElement(model.FoodId).UserId).ToList();
                if(user_basket_items.Count() == 0)
                {
                    Basket basket = new() { FoodId = model.FoodId, UserId = userId };
                    basket.BasketSizes = _mapper.Map<List<BasketSize>>(model.BasketSizes);

                    if (_basket.Any(x => x.UserId == userId && x.FoodId == model.FoodId))
                    {
                        int basketId = _basket.Find(x => x.UserId == userId && x.FoodId == model.FoodId).BasketId;

                        _basketSize.RemoveRange(_basketSize.GetAll(x => x.BasketId == basketId));
                        _basketSize.Save();


                        List<BasketSize> basketSizes = basket.BasketSizes.ToList();

                        for (int i = 0; i < basketSizes.Count; i++)
                        {
                            basketSizes[i].BasketId = basketId;
                        }

                        _basketSize.AddRange(basketSizes);

                        _basket.Save();

                    }
                    else
                    {

                        _basket.Add(basket);
                    }

                    _basket.Save();
                    return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = _basket.Count(x => x.UserId == userId) });

                }
                else
                {
                    return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = "Not Allowed To Order From Another Chef Until Your Basket Is Full, Please Check Out Your Basket First...." });
                }
                
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpPost("{userId}/[controller]/Single")]
        public IActionResult POST(int userId, DtoBasketSingle model)
        {
            try
            {
                Basket basket;
                if (_basket.Any(x => x.UserId == userId && x.FoodId == model.FoodId))
                {
                    basket = _basket.Find(x => x.UserId == userId && x.FoodId == model.FoodId);
                }
                else
                {
                    basket = new() { FoodId = model.FoodId, UserId = userId };
                    _basket.Add(basket);
                    _basket.Save();
                }

                if (_basketSize.Any(x => x.BasketId == basket.BasketId && x.FoodsSizesId == model.FoodsSizesId))
                {
                    var basketSize = _basketSize.Find(x => x.BasketId == basket.BasketId && x.FoodsSizesId == model.FoodsSizesId);
                    basketSize.Quantity = model.Quantity;
                    _basketSize.Update(basketSize);
                }
                else
                {
                    var basketSize = new BasketSize()
                    {
                        BasketId = basket.BasketId,
                        Quantity = model.Quantity,
                        FoodsSizesId = model.FoodsSizesId
                    };

                    _basketSize.Add(basketSize);
                }

                _basketSize.Save();

                return Ok(new DtoResponseModel()
                {
                    State = true,
                    Message = AppResource.lbTheOperationWasCompletedSuccessfully,
                    Data = _vwBasket.GetAll(x => x.BasketId == basket.BasketId).Sum(x => x.Quantity * x.Price)
                }); 
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpDelete("{userId}/[controller]")]
        public IActionResult Delete(int userId, DtoBasketQuantity model)
        {
            try
            {
                if (_basket.Any(x => x.UserId == userId && x.BasketId == model.BasketId))
                {
                    _basketSize.RemoveRange(_basketSize.GetAll(x => x.FoodsSizesId == model.FoodsSizesId && x.BasketId == model.BasketId));
                    _basketSize.Save();

                    if (!_basketSize.Any(x => x.BasketId == model.BasketId))
                    {
                        _basket.Remove(_basket.Find(x => x.UserId == userId && x.BasketId == model.BasketId));
                        _basket.Save();
                    }
                }
                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = _basket.Count(x => x.UserId == userId) });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpGet("{userId}/[controller]")]
        public IActionResult GET(int userId, int page = 0, int size = 30)
        {
            string lang = CultureInfo.CurrentCulture.Name;
            var vwBaskets = _vwBasket.GetAll(x => x.UserId == userId).OrderByDescending(x => x.BasketId).Skip(page * size).Take(size);
            var total = _vwBasket.GetAll(x => x.UserId == userId).Sum(x => x.Quantity * x.Price);
            var vmBasket = new VmBasket()
            {
                Total = Math.Round(total, 2),
                Delivery = 0,
                Net = Math.Round(total, 2),
                BasketItems = _mapper.Map<List<DtoVwBasket>>(vwBaskets, opt => { opt.Items["culture"] = lang; })
            };
            return Ok(new DtoResponseModel() { State = true, Message = "", Data = vmBasket });
        }

        [HttpGet("{userId}/[controller]/[action]")]
        public IActionResult Total(int userId)
        {
            var total = _vwBasket.GetAll(x => x.UserId == userId).Sum(x => x.Quantity * x.Price);
            return Ok(new DtoResponseModel()
            {
                State = true,
                Message = "",
                Data = new
                {
                    Total = Math.Round(total, 2),
                    Delivery = 0,
                    Net = Math.Round(total, 2),
                }
            });
        }

        [HttpGet("{userId}/[controller]/[action]")]
        public IActionResult Count(int userId)
        {
            var count = _basket.Count(x => x.UserId == userId);
            return Ok(new DtoResponseModel() { State = true, Message = "", Data = count });
        }

        [HttpPut("{userId}/[controller]/[action]")]
        public IActionResult Increase(DtoBasketQuantity model)
        {
            try
            {
                BasketSize basket = _basketSize.Find(x => x.BasketId == model.BasketId && x.FoodsSizesId == model.FoodsSizesId);

                basket.Quantity = basket.Quantity + 1;
                _basketSize.Update(basket);
                _basket.Save();

                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = basket.Quantity });
            }

            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpPut("{userId}/[controller]/[action]")]
        public IActionResult Decrease(DtoBasketQuantity model)
        {
            try
            {
                BasketSize basket = _basketSize.Find(x => x.BasketId == model.BasketId && x.FoodsSizesId == model.FoodsSizesId);

                if (basket.Quantity > 1)
                {
                    basket.Quantity = basket.Quantity - 1;
                    _basketSize.Update(basket);
                    _basketSize.Save();
                }

                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = basket.Quantity });
            }

            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }
        //[HttpPut("{userId}/[controller]/[action]")]
        //public IActionResult IncreaseDecrease(DtoBasketQuantity model)
        //{
        //    try
        //    {
        //        BasketSize basket = _basketSize.Find(x => x.BasketId == model.BasketId && x.FoodsSizesId == model.FoodsSizesId);
        //        if (model.basketstype==Enums.BasketsEnum.Increase)
        //        {
        //            basket.Quantity = basket.Quantity + 1;    
        //        }
        //        else
        //        {
        //            if (basket.Quantity > 1)
        //            {
        //                basket.Quantity = basket.Quantity - 1;     
        //            }
        //        }
        //        _basketSize.Update(basket);
        //        _basketSize.Save();
        //        return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = basket.Quantity });
        //    }
        //    catch (Exception)
        //    {
        //        return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
        //    }
        //}
    }
}

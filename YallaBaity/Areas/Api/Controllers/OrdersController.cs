using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using YallaBaity.Areas.Api.Dto;
using YallaBaity.Areas.Api.Repository;
using YallaBaity.Models;
using YallaBaity.Resources;

namespace YallaBaity.Areas.Api.Controllers
{
    [Route("api/Users")]
    [ApiController]
    public class OrdersController : Controller
    {
        IUnitOfWork _unitOfWork;
        IMapper _mapper;
        public OrdersController(IUnitOfWork unitOfWork, IMapper mapper)
        {
            _unitOfWork = unitOfWork;
            _mapper = mapper;
        }

        [HttpPost("{userId}/[controller]")]
        public IActionResult POST(int userId, DtoFoodOrder model)
        {
            try
            {
                if (_unitOfWork.Baskets.Count(x => x.UserId == userId) > 0)
                {
                    var total = _unitOfWork.VwBaskets.GetAll(x => x.UserId == userId).Sum(x => x.Quantity * x.Price);

                    var foodOrder = new FoodOrder()
                    {
                        OrderDate = DateTime.Now,
                        UserId = userId,
                        UsersAddressId = model.UsersAddressId,
                        PaymentMethodsId = model.PaymentMethodsId,
                        HandDate = DateTime.Parse(model.HandDate, CultureInfo.InvariantCulture),
                        IsSchedule = model.IsSchedule,
                        Total = Math.Round(total, 2),
                        NetTotal = Math.Round(total, 2),
                        DeliveryCost = 0,
                        OrderStatusId = 1,
                        OrderCode = string.Format("{0:00000}", _unitOfWork.FoodOrders.NewId(x => x.OrderId)),
                    };


                    _unitOfWork.FoodOrders.Add(foodOrder);
                    _unitOfWork.Save();

                    return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = model });
                }
                else
                {
                    return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbThereAreNoFoodsInTheBasket, Data = new { } });
                }
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpPut("{userId}/[controller]/{orderId}")]
        public IActionResult PUT(int userId, DtoFoodOrder model, int orderId)
        {
            try
            {
                FoodOrder foodOrder = _unitOfWork.FoodOrders.Find(x => x.UserId == userId && x.OrderId == orderId);
                foodOrder.PaymentMethodsId = model.PaymentMethodsId;
                foodOrder.HandDate = DateTime.Parse(model.HandDate, CultureInfo.InvariantCulture);
                foodOrder.UsersAddressId = model.UsersAddressId;
                foodOrder.IsSchedule = model.IsSchedule;

                _unitOfWork.FoodOrders.Update(foodOrder);
                _unitOfWork.Save();
                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = foodOrder });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpDelete("{userId}/[controller]/{id}")]
        public IActionResult Delete(int id)
        {
            try
            {
                _unitOfWork.OrderDetails.RemoveRange(_unitOfWork.OrderDetails.GetAll(x => x.OrderId == id));
                _unitOfWork.OrderDetails.Save();

                _unitOfWork.FoodOrders.Remove(id);
                _unitOfWork.Save();
                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = new { } });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpGet("{userId}/[controller]/{id}")]
        public IActionResult GET(int id)
        {
            try
            {
                var orderDetails = _unitOfWork.VwOrderDetails.GetAll(x => x.OrderId == id);
                var order = _unitOfWork.VwFoodOrders.Find(x => x.OrderId == id);
                string lang = CultureInfo.CurrentCulture.Name;

                return Ok(new DtoResponseModel()
                {
                    State = true,
                    Message = AppResource.lbTheOperationWasCompletedSuccessfully,
                    Data = new
                    {
                        Order = _mapper.Map<DtoVwFoodOrder>(order, opt => { opt.Items["culture"] = lang; }),
                        OrderDetails = _mapper.Map<List<DtoOrderDetail>>(orderDetails, opt => { opt.Items["culture"] = lang; }),
                    }
                });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpGet("{userId}/[controller]")]
        public IActionResult GetByUser(int userId)
        {
            try
            {
                var orders = _unitOfWork.VwOrderDetails.GetAll(x => x.UserId == userId);
                string lang = CultureInfo.CurrentCulture.Name;

                return Ok(new DtoResponseModel()
                {
                    State = true,
                    Message = AppResource.lbTheOperationWasCompletedSuccessfully,
                    Data = _mapper.Map<List<DtoOrderDetail>>(orders, opt => { opt.Items["culture"] = lang; })
                });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpGet("{userId}/[controller]/Count/{statusId}")]
        public IActionResult Count(int userId,int statusId)
        {
            try
            { 
                return Ok(new DtoResponseModel()
                {
                    State = true,
                    Message = AppResource.lbTheOperationWasCompletedSuccessfully,
                    Data = _unitOfWork.FoodOrders.Count(x => x.UserId == userId &&x.OrderStatusId== statusId),
                });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }
    }
}

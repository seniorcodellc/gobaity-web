using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Globalization;
using System.Linq;
using YallaBaity.Areas.Api.Dto;
using YallaBaity.Areas.Api.Repository;
using YallaBaity.Areas.Api.ViewModel;
using YallaBaity.Models;
using YallaBaity.Resources;
using YallaBaity.SignalrHubs;

namespace YallaBaity.Areas.Api.Controllers
{
    [Route("api/Users")]
    [ApiController]
    public class OrdersController : Controller
    {
        IUnitOfWork _unitOfWork;
        IMapper _mapper;
        private readonly IHubContext<ProviderHubs> _hub;
        public OrdersController(IUnitOfWork unitOfWork, IMapper mapper, IHubContext<ProviderHubs> hub)
        {
            _unitOfWork = unitOfWork;
            _mapper = mapper;
            _hub = hub;
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
                        DeliveryTime = DateTime.ParseExact(model.DeliveryTime, "dd-MM-yyyy HH:mm", CultureInfo.InvariantCulture),
                        ProviderId = model.Provider_Id,
                        IsSchedule = model.IsSchedule,
                        Total = Math.Round(total, 2),
                        NetTotal = Math.Round(total, 2),
                        DeliveryCost = 0,
                        OrderStatusId = 1,
                        OrderCode = string.Format("{0:00000}",
                        _unitOfWork.FoodOrders.NewId(x => x.OrderId)),
                    };
                    _unitOfWork.FoodOrders.Add(foodOrder);
                    _unitOfWork.Save();
                    var providerNewOrdersCount = _unitOfWork.FoodOrders.GetAll(c => c.ProviderId == foodOrder.ProviderId && c.OrderStatusId == 1).Count();
                    _hub.Clients.All.SendAsync("orderCountValue", providerNewOrdersCount, foodOrder.ProviderId);
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
                foodOrder.DeliveryTime = DateTime.Parse(model.DeliveryTime, CultureInfo.InvariantCulture);
                foodOrder.UsersAddressId = model.UsersAddressId;
                foodOrder.IsSchedule = model.IsSchedule;
                foodOrder.ProviderId = model.Provider_Id;
                foodOrder.OrderStatusId = model.StatusId;

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
        public IActionResult GetByUser(int userId, [FromQuery] DtoSearch dtoSearch)
        {
            try
            {
                var orders = _unitOfWork.VwOrderDetails.GetAll(x => x.UserId == userId).Skip(dtoSearch.page * dtoSearch.size).Take(dtoSearch.size);
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
        [HttpGet]
        [Route("[controller]/[Action]")]
        public IActionResult FilterOrders(int? userId, int? providerId, int? statusId, int page = 0, int? size = 30)
        {
            try
            {
                var foodOrders = _unitOfWork.FoodOrders.GetAll(c => (userId != null ? c.UserId == userId : 1 == 1)
                && (providerId != null ? c.ProviderId == providerId : 1 == 1)
                && (statusId != null ? c.OrderStatusId == statusId : 1 == 1))
                    .Include(s => s.OrderDetails).ThenInclude(s => s.Food)
                    .Include(s => s.OrderDetails).ThenInclude(s => s.Food).ThenInclude(s => s.FoodsImages)
                    .Include(s => s.OrderDetails).ThenInclude(s => s.OrderSizes).ThenInclude(s => s.FoodsSizes).ThenInclude(s => s.Food)
                    .Include(s => s.OrderDetails).ThenInclude(s => s.OrderSizes).ThenInclude(s => s.FoodsSizes).ThenInclude(s => s.Size)
                    .Include(s => s.OrderStatus)
                    .Include(s => s.UsersAddress)
                    .Include(s => s.User)
                    .OrderBy(c => c.OrderDate).Skip((page) * (int)size).Take((int)size).ToList();
                List<VmFoodOrder> myFoodOrders = new List<VmFoodOrder>();
                VmFoodOrder myFoodOrder = new VmFoodOrder();
                foreach (var item in foodOrders)
                {
                    myFoodOrder = new VmFoodOrder()
                    {
                        ID = item.OrderId,
                        ClientId = item.UserId,
                        ClientName = item.User.UserName,
                        ClientAddress = item.UsersAddress.Address,
                        ClientAddressLink = "http://www.google.com/maps/place/" + item.UsersAddress.Latitude + "," + item.UsersAddress.Longitude,
                        DeliveryCost = item.DeliveryCost,
                        NetTotal = item.NetTotal,
                        Total = item.Total,
                        StatusId = item.OrderStatusId,
                        StatusName = item.OrderStatus.OrderStatusEname,
                        OrderDate = item.OrderDate,
                        OrderDetails = new List<VmOrderDetails>()
                    };

                    foreach (var item1 in item.OrderDetails)
                    {
                        var foodImage = item1.Food.FoodsImages.FirstOrDefault();
                        var orderDetail = new VmOrderDetails()
                        {
                            ID = item1.OrderDetailsId,
                            FoodId = item1.FoodId,
                            FoodName = item1.Food.FoodName,
                            Quantity = item1.OrderSizes.Sum(c => c.Quantity),
                            ProviderId = item1.Food.UserId,
                            ProviderName = _unitOfWork.Users.GetElement(item1.Food.UserId).UserName,
                            ImagePath = foodImage != null ? foodImage.ImagePath : "",
                            OrderDetailSizes = new List<VmOrderDetailSizes>()
                        };
                        foreach (var item2 in item1.OrderSizes)
                        {
                            orderDetail.OrderDetailSizes.Add(new VmOrderDetailSizes()
                            {
                                ID = item2.OrderSizesId,
                                Quantity = item2.Quantity,
                                SizeName = item2.FoodsSizes.Size.SizeEname,
                                SizeId = item2.FoodsSizes.SizeId,
                                Price = item2.FoodsSizes.Price
                            });
                        }
                        myFoodOrder.OrderDetails.Add(orderDetail);
                    }

                    myFoodOrders.Add(myFoodOrder);
                }
                return Ok(new DtoResponseModel()
                {
                    State = true,
                    Message = AppResource.lbTheOperationWasCompletedSuccessfully,
                    Data = myFoodOrders
                });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpGet]
        [Route("[controller]/[Action]")]
        public IActionResult CountOrders(int? userId, int? providerId)
        {
            try
            {
                var foodOrders = _unitOfWork.FoodOrders.GetAll(c => (userId != null ? c.UserId == userId : 1 == 1)
                && (providerId != null ? c.ProviderId == providerId : 1 == 1));
                return Ok(new DtoResponseModel()
                {
                    State = true,
                    Message = AppResource.lbTheOperationWasCompletedSuccessfully,
                    Data = new VmOrderStatusTotal  {
                        Pending = foodOrders.Where(c => c.OrderStatusId == 1).Count(), 
                        Preparing = foodOrders.Where(c => c.OrderStatusId == 2).Count(),
                        Prepared = foodOrders.Where(c => c.OrderStatusId == 3).Count(),
                        Delivering = foodOrders.Where(c => c.OrderStatusId == 4).Count(),
                        Delivered = foodOrders.Where(c => c.OrderStatusId == 5).Count()
                    }
                });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpGet("[controller]/{ProviderID}")]
        public IActionResult GetOrdersByProvider(int ProviderID, [FromQuery] DtoSearch dtoSearch)
        {
            try
            {
                var orders = _unitOfWork.VwOrderDetails.GetAll(x => x.ProviderId == ProviderID).Skip(dtoSearch.page * dtoSearch.size).Take(dtoSearch.size);
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
        [HttpGet("GetOrdersByProviderNext/{ProviderID}")]
        public IActionResult GetOrdersByProviderNext(int ProviderID, [FromQuery] DtoSearch dtoSearch)
        {
            try
            {
                var orders = _unitOfWork.VwOrderDetails.GetAll(x => x.ProviderId == ProviderID).Skip(dtoSearch.page * dtoSearch.size).Take(dtoSearch.size);
                orders = orders.Where(s => s.DeliveryTime > DateTime.Now);
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
        [HttpPut("[controller]/{OrderID}")]
        public IActionResult CheckStartOrder(int OrderID)
        {
            try
            {
                var orders = _unitOfWork.FoodOrders.Find(s => s.OrderId == OrderID);
                if (orders == null)
                {
                    return Ok(new DtoResponseModel()
                    {
                        State = false,
                        Message = "NoFound",
                        Data = null
                    });

                }
                if (orders.IsPending == true)
                {
                    orders.IsPending = false;
                }
                else
                {
                    orders.IsPending = true;
                }

                _unitOfWork.FoodOrders.Update(orders);
                _unitOfWork.Save();
                string lang = CultureInfo.CurrentCulture.Name;
                return Ok(new DtoResponseModel()
                {
                    State = true,
                    Message = AppResource.lbTheOperationWasCompletedSuccessfully,
                    Data = orders
                });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpGet("{userId}/[controller]/Count/{statusId}")]
        public IActionResult Count(int userId, int statusId)
        {
            try
            {
                return Ok(new DtoResponseModel()
                {
                    State = true,
                    Message = AppResource.lbTheOperationWasCompletedSuccessfully,
                    Data = _unitOfWork.FoodOrders.Count(x => x.UserId == userId && x.OrderStatusId == statusId),
                });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }
    }
}

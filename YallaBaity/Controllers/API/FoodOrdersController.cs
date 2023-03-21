using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;
using YallaBaity.Models;
using YallaBaity.Models.Repository;
using YallaBaity.Models.ViewModels;

namespace YallaBaity.Controllers.API
{
    [Route("api/[controller]")]
    [ApiController]
    public class FoodOrdersController : ControllerBase
    {
        private readonly Repository<FoodOrder> _foodOrder;
        private readonly Repository<User> _user;
        private readonly Repository<UsersAddress> _usersAddress;
        private readonly Repository<OrderDetail> _orderDetail;
        private readonly Repository<OrderSize> _orderSize;
        private readonly Repository<Size> _size;
        private readonly Repository<FoodsSize> _foodSize;
        private readonly Repository<Food> _food;
        private readonly Repository<OrderStatus> _orderStatus;

        public FoodOrdersController(IRepository<FoodOrder> foodOrder, IRepository<User> user, 
            IRepository<UsersAddress> usersAddress, IRepository<OrderDetail> orderDetail,
            IRepository<OrderSize> orderSize, IRepository<Size> size, IRepository<FoodsSize> foodSize,
            IRepository<Food> food, IRepository<OrderStatus> orderStatus)
        {
            _foodOrder = (Repository<FoodOrder>)foodOrder;
            _user = (Repository<User>)user;
            _usersAddress = (Repository<UsersAddress>)usersAddress;
            _orderDetail = (Repository<OrderDetail>)orderDetail;
            _orderSize = (Repository<OrderSize>)orderSize;
            _foodSize = (Repository<FoodsSize>)foodSize;
            _size = (Repository<Size>)size;
            _food = (Repository<Food>)food;
            _orderStatus = (Repository<OrderStatus>)orderStatus;
        }

        //https://localhost:44310/api/foodorders/getall?clientId=&providerId=&statusId=1&page=3
        [HttpGet]
        [Route("GetAll")]
        public IActionResult GetAll(int? clientId, int? providerId, int? statusId,int page = 1)
        {
            var ienumerableFoodOrders = _foodOrder.GetAll(null, null, "OrderDetails,OrderDetails.Food,User,UsersAddress,OrderStatus,OrderDetails.Food,OrderDetails.OrderSizes,OrderDetails.OrderSizes.FoodsSizes.Size");
            var foodOrders = ienumerableFoodOrders.ToList();
            if(clientId != null)
            {
                foodOrders = foodOrders.Where(c => c.UserId == clientId).ToList();
            }
            if (statusId != null)
            {
                foodOrders = foodOrders.Where(c => c.OrderStatusId == statusId).ToList();
            }
            if(providerId != null)
            {
                foodOrders = foodOrders.Where(c => c.OrderDetails.Where(x => x.Food.UserId == providerId).Count() > 0).ToList();
            }
            foodOrders = foodOrders.OrderBy(c => c.OrderDate).Skip((page - 1) * 3).Take(3).ToList(); //foodOrders.GetRange(((page - 1) * 3), 3).ToList();
            List<VmFoodOrder> myFoodOrders = new List<VmFoodOrder>();
            VmFoodOrder myFoodOrder = new VmFoodOrder();
            foreach(var item in foodOrders)
            {
                myFoodOrder = new VmFoodOrder() { 
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

                foreach(var item1 in item.OrderDetails)
                {
                    var orderDetail = new VmOrderDetails()
                    {
                        ID = item1.OrderDetailsId,
                        FoodId = item1.FoodId,
                        FoodName = item1.Food.FoodName,
                        Quantity = item1.OrderSizes.Sum(c => c.Quantity),
                        ProviderId = item1.Food.UserId,
                        ProviderName = _user.GetElement(item1.Food.UserId).UserName,
                        OrderDetailSizes = new List<VmOrderDetailSizes>()
                    };
                    foreach(var item2 in item1.OrderSizes)
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
            return Ok(myFoodOrders);
        }

    }
}

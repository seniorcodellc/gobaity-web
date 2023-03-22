using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace YallaBaity.Models.Repository
{
    public class FoodOrderRepository
    {
        private static DbContextOptions<YallaBaityDBContext> Options = new DbContextOptionsBuilder<YallaBaityDBContext>().UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString()).Options;
        private static YallaBaityDBContext databasecontext = new YallaBaityDBContext(Options);

        public List<FoodOrder> GetAll(int? userId, int? statusId)
        {
            List<FoodOrder> foodOrders = new List<FoodOrder>();
            foodOrders = databasecontext.FoodOrders.ToList();
            if (userId != null)
            {
                foodOrders = foodOrders.Where(c => c.UserId == userId).ToList();
            }
            if(statusId != null)
            {
                foodOrders = foodOrders.Where(c => c.OrderStatusId == statusId).ToList();
            }
            return foodOrders;
        }
    }
}

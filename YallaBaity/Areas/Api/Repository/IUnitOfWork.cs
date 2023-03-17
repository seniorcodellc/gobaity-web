using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using YallaBaity.Models;

namespace YallaBaity.Areas.Api.Repository
{
    public interface IUnitOfWork : IDisposable
    {
        IBaseRepository<Ad> Ads { get; }
        IBaseRepository<Category> Categories { get; }
        IBaseRepository<DashBoardUser> DashBoardUsers { get; }
        IBaseRepository<Driver> Drivers { get; }
        IBaseRepository<Food> Foods { get; }
        IBaseRepository<FoodsImage> FoodsImages { get; }
        IBaseRepository<FoodsSize> FoodsSizes { get; }
        IBaseRepository<Governorate> Governorates { get; }
        IBaseRepository<Group> Groups { get; }
        IBaseRepository<GroupPermission> GroupPermissions { get; }
        IBaseRepository<FoodOrder> FoodOrders { get; }
        IBaseRepository<OrderDetail> OrderDetails { get; }
        IBaseRepository<Page> Pages { get; }
        IBaseRepository<PagesTab> PagesTabs { get; }
        IBaseRepository<Size> Sizes { get; }
        IBaseRepository<User> Users { get; }
        IBaseRepository<UserRating> UserRatings { get; }
        IBaseRepository<UsersView> UsersViews { get; }
        IBaseRepository<UsersFavorite> UsersFavorites { get; }
        IBaseRepository<FoodCategory> FoodCategories { get; } 
        IBaseRepository<Basket> Baskets { get; }
        IBaseRepository<UsersAddress> UsersAddresses { get; }
        IBaseRepository<Information> Informations { get; }
        IBaseRepository<Wallet> Wallets { get; }
        IBaseRepository<WalletHistory> WalletHistories{ get; }
        IBaseRepository<VwCategory> VwCategorys { get; }
        IBaseRepository<VwDashBoardUser> VwDashBoardUsers { get; }
        IBaseRepository<VwFood> VwFoods { get; }
        IBaseRepository<VwGroup> VwGroups { get; } 
        IBaseRepository<VwPagesGroupPermission> VwPagesGroupPermissions { get; } 
        IBaseRepository<VwSize> VwSizes { get; }
        IBaseRepository<VwUser> VwUsers { get; }
        IBaseRepository<VwFoodsSize> VwFoodsSizes { get; }
        IBaseRepository<VwUserRating> VwUserRatings { get; }
        IBaseRepository<VwOrderDetail> VwOrderDetails { get; }
        IBaseRepository<VwBasket> VwBaskets { get; }
        IBaseRepository<VwProvider> VwProviders { get; }
        IBaseRepository<VwFoodCategory> VwFoodCategories { get; } 
        IBaseRepository<VwFoodOrder> VwFoodOrders { get; }
        IBaseRepository<VwWalletHistory> VwWalletHistories { get; }

        int Save();
    }
}

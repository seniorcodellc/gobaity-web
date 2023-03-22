
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using YallaBaity.Models;

namespace YallaBaity.Areas.Api.Repository
{
    public class UnitOfWork : IUnitOfWork
    {
        protected YallaBaityDBContext _context;
        public UnitOfWork(YallaBaityDBContext context)
        {
            _context = context;

            Ads = new BaseRepository<Ad>(context);
            Categories = new BaseRepository<Category>(context);
            DashBoardUsers = new BaseRepository<DashBoardUser>(context);
            Drivers = new BaseRepository<Driver>(context);
            Foods = new BaseRepository<Food>(context);
            FoodsImages = new BaseRepository<FoodsImage>(context);
            FoodsSizes = new BaseRepository<FoodsSize>(context);
            Governorates = new BaseRepository<Governorate>(context);
            Groups = new BaseRepository<Group>(context);
            GroupPermissions = new BaseRepository<GroupPermission>(context);
            FoodOrders = new BaseRepository<FoodOrder>(context);
            OrderDetails = new BaseRepository<OrderDetail>(context);
            OrderSizes = new BaseRepository<OrderSize>(context);
            Pages = new BaseRepository<Page>(context);
            PagesTabs = new BaseRepository<PagesTab>(context);
            Sizes = new BaseRepository<Size>(context);
            Users = new BaseRepository<User>(context);
            UserRatings = new BaseRepository<UserRating>(context);
            UsersViews = new BaseRepository<UsersView>(context);
            UsersFavorites = new BaseRepository<UsersFavorite>(context);
            FoodCategories = new BaseRepository<FoodCategory>(context); 
            Baskets = new BaseRepository<Basket>(context);
            BasketSizes = new BaseRepository<BasketSize>(context); 
            UsersAddresses = new BaseRepository<UsersAddress>(context);
            VwCategorys = new BaseRepository<VwCategory>(context);
            VwDashBoardUsers = new BaseRepository<VwDashBoardUser>(context);
            VwFoods = new BaseRepository<VwFood>(context);
            VwGroups = new BaseRepository<VwGroup>(context); 
            VwPagesGroupPermissions = new BaseRepository<VwPagesGroupPermission>(context); 
            VwSizes = new BaseRepository<VwSize>(context);
            VwUsers = new BaseRepository<VwUser>(context);
            VwFoodsSizes = new BaseRepository<VwFoodsSize>(context);
            VwUserRatings = new BaseRepository<VwUserRating>(context);
            VwOrderDetails = new BaseRepository<VwOrderDetail>(context);
            VwBaskets = new BaseRepository<VwBasket>(context);
            VwProviders = new BaseRepository<VwProvider>(context);
            VwFoodCategories=new BaseRepository<VwFoodCategory>(context);
            VwFoodOrders=new BaseRepository<VwFoodOrder>(context);
            Informations=new BaseRepository<Information>(context);
            Wallets=new BaseRepository<Wallet>(context);
            WalletHistories=new BaseRepository<WalletHistory>(context);
            VwWalletHistories = new BaseRepository<VwWalletHistory>(context);
        }

        public IBaseRepository<Ad> Ads { get; private set; } 
        public IBaseRepository<Category> Categories { get; private set; } 
        public IBaseRepository<DashBoardUser> DashBoardUsers { get; private set; } 
        public IBaseRepository<Driver> Drivers { get; private set; } 
        public IBaseRepository<Food> Foods { get; private set; } 
        public IBaseRepository<FoodsImage> FoodsImages { get; private set; } 
        public IBaseRepository<FoodsSize> FoodsSizes { get; private set; } 
        public IBaseRepository<Governorate> Governorates { get; private set; } 
        public IBaseRepository<Group> Groups { get; private set; } 
        public IBaseRepository<GroupPermission> GroupPermissions { get; private set; } 
        public IBaseRepository<FoodOrder> FoodOrders { get; private set; } 
        public IBaseRepository<OrderDetail> OrderDetails { get; private set; }
        public IBaseRepository<OrderSize> OrderSizes { get; private set; }
        public IBaseRepository<Page> Pages { get; private set; } 
        public IBaseRepository<PagesTab> PagesTabs { get; private set; } 
        public IBaseRepository<Size> Sizes { get; private set; } 
        public IBaseRepository<User> Users { get; private set; } 
        public IBaseRepository<UserRating> UserRatings { get; private set; } 
        public IBaseRepository<UsersView> UsersViews { get; private set; }
        public IBaseRepository<FoodCategory> FoodCategories { get; private set; } 
        public IBaseRepository<UsersFavorite> UsersFavorites { get; private set; }
        public IBaseRepository<Basket> Baskets { get; private set; }
        public IBaseRepository<BasketSize> BasketSizes { get; private set; } 
        public IBaseRepository<VwCategory> VwCategorys { get; private set; } 
        public IBaseRepository<VwDashBoardUser> VwDashBoardUsers { get; private set; } 
        public IBaseRepository<VwFood> VwFoods { get; private set; } 
        public IBaseRepository<VwGroup> VwGroups { get; private set; } 
        public IBaseRepository<VwPagesGroupPermission> VwPagesGroupPermissions { get; private set; } 
        public IBaseRepository<VwSize> VwSizes { get; private set; } 
        public IBaseRepository<VwUser> VwUsers { get; private set; } 
        public IBaseRepository<VwFoodsSize> VwFoodsSizes { get; private set; }
        public IBaseRepository<VwUserRating> VwUserRatings { get; private set; }
        public IBaseRepository<VwOrderDetail> VwOrderDetails { get; private set; }
        public IBaseRepository<VwBasket> VwBaskets { get; private set; }
        public IBaseRepository<VwProvider> VwProviders { get; private set; }
        public IBaseRepository<VwFoodCategory> VwFoodCategories { get; private set; }
        public IBaseRepository<UsersAddress> UsersAddresses { get; private set; }
        public IBaseRepository<VwFoodOrder> VwFoodOrders { get; private set; }
        public IBaseRepository<Information> Informations { get; private set; }
        public IBaseRepository<Wallet> Wallets { get; private set; }
        public IBaseRepository<WalletHistory> WalletHistories { get; private set; }
        public IBaseRepository<VwWalletHistory> VwWalletHistories { get; private set; }      
        public void Dispose()
        {
            _context.Dispose();
        }
        public int Save()
        {
            return _context.SaveChanges();
        }
    }
}

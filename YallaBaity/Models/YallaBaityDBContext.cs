using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

#nullable disable

namespace YallaBaity.Models
{
    public partial class YallaBaityDBContext : DbContext
    {
        public YallaBaityDBContext()
        {
        }

        public YallaBaityDBContext(DbContextOptions<YallaBaityDBContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Ad> Ads { get; set; }
        public virtual DbSet<Basket> Baskets { get; set; }
        public virtual DbSet<BasketSize> BasketSizes { get; set; }
        public virtual DbSet<Category> Categories { get; set; }
        public virtual DbSet<DashBoardUser> DashBoardUsers { get; set; }
        public virtual DbSet<Driver> Drivers { get; set; }
        public virtual DbSet<Food> Foods { get; set; }
        public virtual DbSet<FoodCategory> FoodCategories { get; set; }
        public virtual DbSet<FoodOrder> FoodOrders { get; set; }
        public virtual DbSet<FoodsImage> FoodsImages { get; set; }
        public virtual DbSet<FoodsSize> FoodsSizes { get; set; }
        public virtual DbSet<Governorate> Governorates { get; set; }
        public virtual DbSet<Group> Groups { get; set; }
        public virtual DbSet<GroupPermission> GroupPermissions { get; set; }
        public virtual DbSet<Information> Information { get; set; }
        public virtual DbSet<OrderDetail> OrderDetails { get; set; }
        public virtual DbSet<OrderSize> OrderSizes { get; set; }
        public virtual DbSet<OrderStatus> OrderStatuses { get; set; }
        public virtual DbSet<Page> Pages { get; set; }
        public virtual DbSet<PagesTab> PagesTabs { get; set; }
        public virtual DbSet<PaymentMethod> PaymentMethods { get; set; }
        public virtual DbSet<Size> Sizes { get; set; }
        public virtual DbSet<User> Users { get; set; }
        public virtual DbSet<UserRating> UserRatings { get; set; }
        public virtual DbSet<UsersAddress> UsersAddresses { get; set; }
        public virtual DbSet<UsersFavorite> UsersFavorites { get; set; }
        public virtual DbSet<UsersView> UsersViews { get; set; }
        public virtual DbSet<VwBasket> VwBaskets { get; set; }
        public virtual DbSet<VwCategory> VwCategories { get; set; }
        public virtual DbSet<VwDashBoardUser> VwDashBoardUsers { get; set; }
        public virtual DbSet<VwFood> VwFoods { get; set; }
        public virtual DbSet<VwFoodCategory> VwFoodCategories { get; set; }
        public virtual DbSet<VwFoodOrder> VwFoodOrders { get; set; }
        public virtual DbSet<VwFoodsSize> VwFoodsSizes { get; set; }
        public virtual DbSet<VwGroup> VwGroups { get; set; }
        public virtual DbSet<VwOrderDetail> VwOrderDetails { get; set; }
        public virtual DbSet<VwPagesGroupPermission> VwPagesGroupPermissions { get; set; }
        public virtual DbSet<VwProvider> VwProviders { get; set; }
        public virtual DbSet<VwSize> VwSizes { get; set; }
        public virtual DbSet<VwUser> VwUsers { get; set; }
        public virtual DbSet<VwUserRating> VwUserRatings { get; set; }
        public virtual DbSet<VwWalletHistory> VwWalletHistories { get; set; }
        public virtual DbSet<Wallet> Wallets { get; set; }
        public virtual DbSet<WalletHistory> WalletHistories { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
            //    optionsBuilder.UseSqlServer("Server=sql.bsite.net\\MSSQL2016;Database=crashdell_YallaBaityDB;Trusted_Connection=False;User Id=crashdell_YallaBaityDB;Password=YallaBaityDB;MultipleActiveResultSets=true");
                optionsBuilder.UseSqlServer("Server=DESKTOP-8V47LUC\\SQLEXPRESS;Database=YallaBaityDB;Trusted_Connection=True;");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasAnnotation("Relational:Collation", "Arabic_CI_AS");

            modelBuilder.Entity<Ad>(entity =>
            {
                entity.HasKey(e => e.AdsId);

                entity.ToTable("Ads", "food");

                entity.Property(e => e.AdsId).ValueGeneratedNever();

                entity.Property(e => e.AdsImage)
                    .IsRequired()
                    .HasMaxLength(100);
            });

            modelBuilder.Entity<Basket>(entity =>
            {
                entity.ToTable("Basket", "food");

                entity.HasOne(d => d.Food)
                    .WithMany(p => p.Baskets)
                    .HasForeignKey(d => d.FoodId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Basket_Foods");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.Baskets)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Basket_Users");
            });

            modelBuilder.Entity<BasketSize>(entity =>
            {
                entity.HasKey(e => e.BasketSizesId);

                entity.ToTable("BasketSizes", "food");

                entity.HasOne(d => d.Basket)
                    .WithMany(p => p.BasketSizes)
                    .HasForeignKey(d => d.BasketId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_BasketSizes_Basket");

                entity.HasOne(d => d.FoodsSizes)
                    .WithMany(p => p.BasketSizes)
                    .HasForeignKey(d => d.FoodsSizesId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_BasketSizes_FoodsSizes");
            });

            modelBuilder.Entity<Category>(entity =>
            {
                entity.ToTable("Categories", "food");

                entity.Property(e => e.CategoryAdescription)
                    .HasMaxLength(100)
                    .HasColumnName("CategoryADescription");

                entity.Property(e => e.CategoryAname)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.CategoryEdescription)
                    .HasMaxLength(100)
                    .HasColumnName("CategoryEDescription");

                entity.Property(e => e.CategoryEname)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.ImagePath)
                    .IsRequired()
                    .HasMaxLength(100);
            });

            modelBuilder.Entity<DashBoardUser>(entity =>
            {
                entity.HasKey(e => e.UserId);

                entity.ToTable("DashBoardUsers", "Auth");

                entity.Property(e => e.Email).HasMaxLength(50);

                entity.Property(e => e.Password)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.UserName)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.HasOne(d => d.Group)
                    .WithMany(p => p.DashBoardUsers)
                    .HasForeignKey(d => d.GroupId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_DashBoardUsers_Groups");
            });

            modelBuilder.Entity<Driver>(entity =>
            {
                entity.ToTable("Drivers", "order");

                entity.Property(e => e.DriverName)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.DrivingLicenseBack)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.DrivingLicenseFace)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.HealthCertificateBack)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.HealthCertificateFace)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.NationalIdcardBack)
                    .IsRequired()
                    .HasMaxLength(100)
                    .HasColumnName("NationalIDCardBack");

                entity.Property(e => e.NationalIdcardFace)
                    .IsRequired()
                    .HasMaxLength(100)
                    .HasColumnName("NationalIDCardFace");

                entity.Property(e => e.Password)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.PersonalLicenseBack)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.PersonalLicenseFace)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.Phone)
                    .IsRequired()
                    .HasMaxLength(50);
            });

            modelBuilder.Entity<Food>(entity =>
            {
                entity.ToTable("Foods", "food");

                entity.Property(e => e.FoodId).ValueGeneratedNever();

                entity.Property(e => e.CreationDate).HasColumnType("datetime");

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(500);

                entity.Property(e => e.FoodName)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.Price).HasColumnType("decimal(18, 2)");
            });

            modelBuilder.Entity<FoodCategory>(entity =>
            {
                entity.HasKey(e => e.FoodCategoriesId);

                entity.ToTable("FoodCategories", "food");

                entity.HasOne(d => d.Category)
                    .WithMany(p => p.FoodCategories)
                    .HasForeignKey(d => d.CategoryId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_FoodCategories_Categorys");

                entity.HasOne(d => d.Food)
                    .WithMany(p => p.FoodCategories)
                    .HasForeignKey(d => d.FoodId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_FoodCategories_Foods");
            });

            modelBuilder.Entity<FoodOrder>(entity =>
            {
                entity.HasKey(e => e.OrderId)
                    .HasName("PK_Order");

                entity.ToTable("FoodOrders", "order");

                entity.Property(e => e.DeliveryCost).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.HandDate).HasColumnType("datetime");

                entity.Property(e => e.NetTotal).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.OrderCode).HasMaxLength(50);

                entity.Property(e => e.OrderDate).HasColumnType("datetime");

                entity.Property(e => e.Total).HasColumnType("decimal(18, 2)");

                entity.HasOne(d => d.Driver)
                    .WithMany(p => p.FoodOrders)
                    .HasForeignKey(d => d.DriverId)
                    .HasConstraintName("FK_Order_Driver");

                entity.HasOne(d => d.OrderStatus)
                    .WithMany(p => p.FoodOrders)
                    .HasForeignKey(d => d.OrderStatusId)
                    .HasConstraintName("FK_FoodOrders_OrderStatus1");

                entity.HasOne(d => d.PaymentMethods)
                    .WithMany(p => p.FoodOrders)
                    .HasForeignKey(d => d.PaymentMethodsId)
                    .HasConstraintName("FK_FoodOrders_PaymentMethods");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.FoodOrders)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Order_Users");

                entity.HasOne(d => d.UsersAddress)
                    .WithMany(p => p.FoodOrders)
                    .HasForeignKey(d => d.UsersAddressId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_FoodOrders_UsersAddress");
            });

            modelBuilder.Entity<FoodsImage>(entity =>
            {
                entity.HasKey(e => e.FoodsImagesId)
                    .HasName("PK_ItemImages");

                entity.ToTable("FoodsImages", "food");

                entity.Property(e => e.ImagePath)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.HasOne(d => d.Food)
                    .WithMany(p => p.FoodsImages)
                    .HasForeignKey(d => d.FoodId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_ItemImages_Items");
            });

            modelBuilder.Entity<FoodsSize>(entity =>
            {
                entity.HasKey(e => e.FoodsSizesId)
                    .HasName("PK_ItemSizes");

                entity.ToTable("FoodsSizes", "food");

                entity.Property(e => e.Price).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.SizeDescription).HasMaxLength(100);

                entity.HasOne(d => d.Food)
                    .WithMany(p => p.FoodsSizes)
                    .HasForeignKey(d => d.FoodId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_ItemSizes_Items");

                entity.HasOne(d => d.Size)
                    .WithMany(p => p.FoodsSizes)
                    .HasForeignKey(d => d.SizeId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_ItemSizes_Sizes");
            });

            modelBuilder.Entity<Governorate>(entity =>
            {
                entity.ToTable("Governorates", "user");

                entity.Property(e => e.GovernorateAname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("GovernorateAName");

                entity.Property(e => e.GovernorateEname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("GovernorateEName");
            });

            modelBuilder.Entity<Group>(entity =>
            {
                entity.ToTable("Groups", "Auth");

                entity.Property(e => e.GroupAname)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.GroupEname)
                    .IsRequired()
                    .HasMaxLength(50);
            });

            modelBuilder.Entity<GroupPermission>(entity =>
            {
                entity.ToTable("GroupPermissions", "Auth");

                entity.HasOne(d => d.Group)
                    .WithMany(p => p.GroupPermissions)
                    .HasForeignKey(d => d.GroupId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_GroupPermission_Groups");

                entity.HasOne(d => d.Page)
                    .WithMany(p => p.GroupPermissions)
                    .HasForeignKey(d => d.PageId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_GroupPermission_Pages");
            });

            modelBuilder.Entity<Information>(entity =>
            {
                entity.ToTable("Information", "common");
            });

            modelBuilder.Entity<OrderDetail>(entity =>
            {
                entity.HasKey(e => e.OrderDetailsId);

                entity.ToTable("OrderDetails", "order");

                entity.HasOne(d => d.Food)
                    .WithMany(p => p.OrderDetails)
                    .HasForeignKey(d => d.FoodId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_OrderDetails_Items");

                entity.HasOne(d => d.Order)
                    .WithMany(p => p.OrderDetails)
                    .HasForeignKey(d => d.OrderId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_OrderDetails_Order");
            });

            modelBuilder.Entity<OrderSize>(entity =>
            {
                entity.HasKey(e => e.OrderSizesId);

                entity.ToTable("OrderSizes", "order");

                entity.HasOne(d => d.FoodsSizes)
                    .WithMany(p => p.OrderSizes)
                    .HasForeignKey(d => d.FoodsSizesId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_OrderSizes_FoodsSizes");

                entity.HasOne(d => d.OrderDetails)
                    .WithMany(p => p.OrderSizes)
                    .HasForeignKey(d => d.OrderDetailsId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_OrderSizes_OrderDetails");
            });

            modelBuilder.Entity<OrderStatus>(entity =>
            {
                entity.ToTable("OrderStatus", "order");

                entity.Property(e => e.OrderStatusId).ValueGeneratedNever();

                entity.Property(e => e.OrderStatusAname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("OrderStatusAName");

                entity.Property(e => e.OrderStatusEname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("OrderStatusEName");
            });

            modelBuilder.Entity<Page>(entity =>
            {
                entity.ToTable("Pages", "Auth");

                entity.Property(e => e.PageAname)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.PageEname)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.PageKey).HasMaxLength(50);

                entity.HasOne(d => d.PagesTab)
                    .WithMany(p => p.Pages)
                    .HasForeignKey(d => d.PagesTabId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Pages_PagesTap");
            });

            modelBuilder.Entity<PagesTab>(entity =>
            {
                entity.ToTable("PagesTabs", "Auth");

                entity.Property(e => e.PagesTabAname)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.PagesTabEname)
                    .IsRequired()
                    .HasMaxLength(50);
            });

            modelBuilder.Entity<PaymentMethod>(entity =>
            {
                entity.HasKey(e => e.PaymentMethodsId);

                entity.ToTable("PaymentMethods", "order");

                entity.Property(e => e.PaymentMethodsId).ValueGeneratedNever();

                entity.Property(e => e.PaymentMethodsAname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("PaymentMethodsAName");

                entity.Property(e => e.PaymentMethodsEname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("PaymentMethodsEName");
            });

            modelBuilder.Entity<Size>(entity =>
            {
                entity.ToTable("Sizes", "food");

                entity.Property(e => e.SizeAname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("SizeAName");

                entity.Property(e => e.SizeEname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("SizeEName");
            });

            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("Users", "user");

                entity.Property(e => e.UserId).ValueGeneratedNever();

                entity.Property(e => e.Address).HasMaxLength(500);

                entity.Property(e => e.CreationDate).HasColumnType("datetime");

                entity.Property(e => e.Image).HasMaxLength(100);

                entity.Property(e => e.NationalIdcard1)
                    .HasMaxLength(100)
                    .HasColumnName("NationalIDCard1");

                entity.Property(e => e.NationalIdcard2)
                    .HasMaxLength(100)
                    .HasColumnName("NationalIDCard2");

                entity.Property(e => e.Otpcode).HasColumnName("OTPCode");

                entity.Property(e => e.OtpdateOfLastSent)
                    .HasColumnType("datetime")
                    .HasColumnName("OTPDateOfLastSent");

                entity.Property(e => e.OtpnumberOfTimesSent).HasColumnName("OTPNumberOfTimesSent");

                entity.Property(e => e.Password)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.Phone)
                    .IsRequired()
                    .HasMaxLength(15);

                entity.Property(e => e.UserName)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.HasOne(d => d.Governorate)
                    .WithMany(p => p.Users)
                    .HasForeignKey(d => d.GovernorateId)
                    .HasConstraintName("FK_Users_Governorates");
            });

            modelBuilder.Entity<UserRating>(entity =>
            {
                entity.ToTable("UserRating", "user");

                entity.Property(e => e.Description).HasMaxLength(400);

                entity.Property(e => e.RatingDate).HasColumnType("date");

                entity.HasOne(d => d.Food)
                    .WithMany(p => p.UserRatings)
                    .HasForeignKey(d => d.FoodId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_UserRating_Items");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.UserRatings)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_UserRating_Users");
            });

            modelBuilder.Entity<UsersAddress>(entity =>
            {
                entity.ToTable("UsersAddress", "user");

                entity.Property(e => e.Address)
                    .IsRequired()
                    .HasMaxLength(900);

                entity.Property(e => e.Street)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.UsersAddressName)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.HasOne(d => d.User)
                    .WithMany(p => p.UsersAddresses)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_UsersAddress_Users");
            });

            modelBuilder.Entity<UsersFavorite>(entity =>
            {
                entity.ToTable("UsersFavorite", "user");

                entity.HasOne(d => d.Food)
                    .WithMany(p => p.UsersFavorites)
                    .HasForeignKey(d => d.FoodId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_UsersLikes_Foods");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.UsersFavorites)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_UsersLikes_Users");
            });

            modelBuilder.Entity<UsersView>(entity =>
            {
                entity.HasKey(e => e.UsersViewsId);

                entity.ToTable("UsersViews", "user");

                entity.HasOne(d => d.Food)
                    .WithMany(p => p.UsersViews)
                    .HasForeignKey(d => d.FoodId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_UsersViews_Items");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.UsersViews)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_UsersViews_Users");
            });

            modelBuilder.Entity<VwBasket>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("VwBasket", "food");

                entity.Property(e => e.CookName)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.FoodName)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.ImagePath).HasMaxLength(100);

                entity.Property(e => e.Price).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.Rate).HasColumnType("decimal(29, 11)");

                entity.Property(e => e.SizeAname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("SizeAName");

                entity.Property(e => e.SizeEname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("SizeEName");
            });

            modelBuilder.Entity<VwCategory>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("VwCategories", "food");

                entity.Property(e => e.CategoryAdescription)
                    .HasMaxLength(100)
                    .HasColumnName("CategoryADescription");

                entity.Property(e => e.CategoryAname)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.CategoryEdescription)
                    .HasMaxLength(100)
                    .HasColumnName("CategoryEDescription");

                entity.Property(e => e.CategoryEname)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.CategoryId).ValueGeneratedOnAdd();

                entity.Property(e => e.ImagePath)
                    .IsRequired()
                    .HasMaxLength(100);
            });

            modelBuilder.Entity<VwDashBoardUser>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("VwDashBoardUsers", "Auth");

                entity.Property(e => e.Email).HasMaxLength(50);

                entity.Property(e => e.GroupAname)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.GroupEname)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.Password)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.UserName)
                    .IsRequired()
                    .HasMaxLength(50);
            });

            modelBuilder.Entity<VwFood>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("VwFood", "food");

                entity.Property(e => e.CookName)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.CreationDate).HasColumnType("datetime");

                entity.Property(e => e.Date).HasMaxLength(36);

                entity.Property(e => e.Description)
                    .IsRequired()
                    .HasMaxLength(500);

                entity.Property(e => e.FoodName)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.ImagePath).HasMaxLength(100);

                entity.Property(e => e.Price).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.Rate).HasColumnType("decimal(29, 11)");
            });

            modelBuilder.Entity<VwFoodCategory>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("VwFoodCategories", "food");
            });

            modelBuilder.Entity<VwFoodOrder>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("VwFoodOrders", "order");

                entity.Property(e => e.Address)
                    .IsRequired()
                    .HasMaxLength(900);

                entity.Property(e => e.DeliveryCost).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.HandDate).HasColumnType("datetime");

                entity.Property(e => e.NetTotal).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.OrderCode).HasMaxLength(50);

                entity.Property(e => e.OrderDate).HasColumnType("datetime");

                entity.Property(e => e.OrderStatusAname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("OrderStatusAName");

                entity.Property(e => e.OrderStatusEname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("OrderStatusEName");

                entity.Property(e => e.PaymentMethodsAname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("PaymentMethodsAName");

                entity.Property(e => e.PaymentMethodsEname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("PaymentMethodsEName");

                entity.Property(e => e.ShortDate).HasMaxLength(36);

                entity.Property(e => e.Street)
                    .IsRequired()
                    .HasMaxLength(100);

                entity.Property(e => e.Total).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.UsersAddressName)
                    .IsRequired()
                    .HasMaxLength(100);
            });

            modelBuilder.Entity<VwFoodsSize>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("VwFoodsSizes", "food");

                entity.Property(e => e.Price).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.SizeAname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("SizeAName");

                entity.Property(e => e.SizeDescription).HasMaxLength(100);

                entity.Property(e => e.SizeEname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("SizeEName");
            });

            modelBuilder.Entity<VwGroup>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("VwGroups", "Auth");

                entity.Property(e => e.GroupAname)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.GroupEname)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.GroupId).ValueGeneratedOnAdd();
            });

            modelBuilder.Entity<VwOrderDetail>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("VwOrderDetails", "order");

                entity.Property(e => e.CookName).HasMaxLength(50);

                entity.Property(e => e.DeliveryCost).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.FoodName).HasMaxLength(50);

                entity.Property(e => e.ImagePath).HasMaxLength(100);

                entity.Property(e => e.NetTotal).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.OrderCode).HasMaxLength(50);

                entity.Property(e => e.OrderDate).HasColumnType("datetime");

                entity.Property(e => e.OrderStatusAname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("OrderStatusAName");

                entity.Property(e => e.OrderStatusEname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("OrderStatusEName");

                entity.Property(e => e.PaymentMethodsAname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("PaymentMethodsAName");

                entity.Property(e => e.PaymentMethodsEname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("PaymentMethodsEName");

                entity.Property(e => e.Price).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.ShortDate).HasMaxLength(36);

                entity.Property(e => e.SizeAname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("SizeAName");

                entity.Property(e => e.SizeEname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("SizeEName");

                entity.Property(e => e.Total).HasColumnType("decimal(18, 2)");
            });

            modelBuilder.Entity<VwPagesGroupPermission>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("VwPagesGroupPermission", "Auth");

                entity.Property(e => e.PageKey).HasMaxLength(50);
            });

            modelBuilder.Entity<VwProvider>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("VwProviders", "user");

                entity.Property(e => e.CookName)
                    .IsRequired()
                    .HasMaxLength(50);
            });

            modelBuilder.Entity<VwSize>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("VwSizes", "food");

                entity.Property(e => e.SizeAname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("SizeAName");

                entity.Property(e => e.SizeEname)
                    .IsRequired()
                    .HasMaxLength(50)
                    .HasColumnName("SizeEName");

                entity.Property(e => e.SizeId).ValueGeneratedOnAdd();
            });

            modelBuilder.Entity<VwUser>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("VwUsers", "user");

                entity.Property(e => e.Address).HasMaxLength(500);

                entity.Property(e => e.CreationDate).HasColumnType("datetime");

                entity.Property(e => e.GovernorateAname)
                    .HasMaxLength(50)
                    .HasColumnName("GovernorateAName");

                entity.Property(e => e.GovernorateEname)
                    .HasMaxLength(50)
                    .HasColumnName("GovernorateEName");

                entity.Property(e => e.Image).HasMaxLength(100);

                entity.Property(e => e.NationalIdcard1)
                    .HasMaxLength(100)
                    .HasColumnName("NationalIDCard1");

                entity.Property(e => e.NationalIdcard2)
                    .HasMaxLength(100)
                    .HasColumnName("NationalIDCard2");

                entity.Property(e => e.Otpcode).HasColumnName("OTPCode");

                entity.Property(e => e.OtpdateOfLastSent)
                    .HasColumnType("datetime")
                    .HasColumnName("OTPDateOfLastSent");

                entity.Property(e => e.OtpnumberOfTimesSent).HasColumnName("OTPNumberOfTimesSent");

                entity.Property(e => e.Password)
                    .IsRequired()
                    .HasMaxLength(50);

                entity.Property(e => e.Phone)
                    .IsRequired()
                    .HasMaxLength(15);

                entity.Property(e => e.UserName)
                    .IsRequired()
                    .HasMaxLength(50);
            });

            modelBuilder.Entity<VwUserRating>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("VwUserRating", "user");

                entity.Property(e => e.Description).HasMaxLength(400);

                entity.Property(e => e.RatingDate).HasMaxLength(36);

                entity.Property(e => e.UserName)
                    .IsRequired()
                    .HasMaxLength(50);
            });

            modelBuilder.Entity<VwWalletHistory>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("VwWalletHistory", "user");

                entity.Property(e => e.Amount).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.Balance).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.Commission).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.Date).HasColumnType("datetime");

                entity.Property(e => e.WalletHistoryId).ValueGeneratedOnAdd();
            });

            modelBuilder.Entity<Wallet>(entity =>
            {
                entity.HasKey(e => e.UserId)
                    .HasName("PK_Wallet_1");

                entity.ToTable("Wallet", "user");

                entity.Property(e => e.UserId).ValueGeneratedNever();

                entity.Property(e => e.Balance).HasColumnType("decimal(18, 2)");

                entity.HasOne(d => d.User)
                    .WithOne(p => p.Wallet)
                    .HasForeignKey<Wallet>(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Wallet_Users1");
            });

            modelBuilder.Entity<WalletHistory>(entity =>
            {
                entity.ToTable("WalletHistory", "user");

                entity.Property(e => e.Amount).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.Balance).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.Commission).HasColumnType("decimal(18, 2)");

                entity.Property(e => e.Date).HasColumnType("datetime");

                entity.HasOne(d => d.Order)
                    .WithMany(p => p.WalletHistories)
                    .HasForeignKey(d => d.OrderId)
                    .HasConstraintName("FK_WalletHistory_FoodOrders");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.WalletHistories)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_WalletHistory_Wallet");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}

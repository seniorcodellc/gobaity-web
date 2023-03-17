using AutoMapper;
using System.Collections.Generic;
using System.Globalization;
using YallaBaity.Areas.Api.Dto;
using YallaBaity.Models;

namespace YallaBaity.Areas.Api.Services
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            /*

              {
       CreateMap<Source, Destination>()
           .ForMember(dest => dest.InstallationDate, conf => conf.MapFrom((src, _, _, context) => src.InstallationDate.ToString((CultureInfo)context.Items["culture"])));
   }

             */


            CreateMap<DtoFoodOrder, FoodOrder>();
            CreateMap<DtoDashBoardUser, DashBoardUser>();
            CreateMap<DtoUsersAddress, UsersAddress>();
            CreateMap<DtoBasketSizes, BasketSize>();
            CreateMap<DtoCategoriesForm, Category>();

            CreateMap<Category, DtoCategories>().ForMember(x => x.CategoryName, x => x.MapFrom((x, _, _, context) => (context.Items["culture"].ToString() == "ar" ? x.CategoryAname : x.CategoryEname))).ForMember(x => x.CategoryDescription, x => x.MapFrom((x, _, _, context) => (context.Items["culture"].ToString() == "ar" ? x.CategoryAdescription : x.CategoryEdescription)));
            CreateMap<Governorate, DtoGovernorates>().ForMember(x => x.GovernorateName, x => x.MapFrom((x, _, _, context) => (context.Items["culture"].ToString() == "ar" ? x.GovernorateAname : x.GovernorateEname)));
            CreateMap<Size, DtoSizesQueary>().ForMember(x => x.SizeName, x => x.MapFrom((x, _, _, context) => (context.Items["culture"].ToString() == "ar" ? x.SizeAname : x.SizeEname)));
            CreateMap<VwFoodsSize, DtoFoodsSizes>().ForMember(x => x.SizeName, x => x.MapFrom((x, _, _, context) => (context.Items["culture"].ToString() == "ar" ? x.SizeAname : x.SizeEname)));
            CreateMap<VwBasket, DtoVwBasket>().ForMember(x => x.SizeName, x => x.MapFrom((x, _, _, context) => (context.Items["culture"].ToString() == "ar" ? x.SizeAname : x.SizeEname)));
            CreateMap<VwFoodOrder, DtoVwFoodOrder>().ForMember(x => x.PaymentMethodsName, x => x.MapFrom((x, _, _, context) => (context.Items["culture"].ToString() == "ar" ? x.PaymentMethodsAname : x.PaymentMethodsEname))).ForMember(x => x.OrderStatusName, x => x.MapFrom((x, _, _, context) => (context.Items["culture"].ToString() == "ar" ? x.OrderStatusAname : x.OrderStatusEname))).ForMember(x => x.OrderDate, x => x.MapFrom(x => x.OrderDate.ToString("dd-MM-yyyy"))).ForMember(x => x.HandDate, x => x.MapFrom(x => x.HandDate.DateToString("dd-MM-yyyy hh:mm tt")));
            CreateMap<VwOrderDetail, DtoOrderDetail>().ForMember(x => x.PaymentMethodsName, x => x.MapFrom((x, _, _, context) => (context.Items["culture"].ToString() == "ar" ? x.PaymentMethodsAname : x.PaymentMethodsEname))).ForMember(x => x.OrderStatusName, x => x.MapFrom((x, _, _, context) => (context.Items["culture"].ToString() == "ar" ? x.OrderStatusAname : x.OrderStatusEname))).ForMember(x => x.SizeName, x => x.MapFrom((x, _, _, context) => (context.Items["culture"].ToString() == "ar" ? x.SizeAname : x.SizeEname))).ForMember(x => x.OrderDate, x => x.MapFrom(x => x.OrderDate.ToString("dd-MM-yyyy")));
        }
    }
}

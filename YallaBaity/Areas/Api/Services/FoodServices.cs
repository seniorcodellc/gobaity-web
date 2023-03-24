using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Primitives;
using System.Collections.Generic;
using System.Globalization;
using System;
using YallaBaity.Models;
using System.Linq;
using Newtonsoft.Json;
using System.Linq.Expressions;
using YallaBaity.Areas.Api.ViewModel;
using System.Text.Json;
using YallaBaity.Areas.Api.Dto;

namespace YallaBaity.Areas.Api.Services
{
    public class FoodServices
    {
        IFilesServices _filesServices;
        IProcedureServices _procedureServices;
        public FoodServices(IFilesServices filesServices, IProcedureServices procedureServices)
        {
            _filesServices = filesServices;
            _procedureServices = procedureServices;
        }

        #region Distances
        private double rad(double x)
        {
            return x * Math.PI / 180;
        }

        public bool CalculateDistance(string slat1, string slng1, double lat2, double lng2)
        {
            if (lat2 == -1 || lng2 == -1) return true;

            var lat1 = double.Parse(slat1, CultureInfo.InvariantCulture);
            var lng1 = double.Parse(slng1, CultureInfo.InvariantCulture);
            var R = 6378137; // Earth’s mean radius in meter
            var dLat = rad(lat2 - lat1);
            var dLong = rad(lng2 - lng1);
            var a = Math.Sin(dLat / 2) * Math.Sin(dLat / 2) + Math.Cos(rad(lat1)) * Math.Cos(rad(lat2)) * Math.Sin(dLong / 2) * Math.Sin(dLong / 2);
            var c = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));
            var d = R * c;

            return (Math.Round(d) < 5000 ? true : false);
        }
        #endregion

        #region Fills
        public List<FoodsImage> FillFoodsImages(IFormFileCollection files, int foodId, bool isUpdate)
        {
            string folderPath = @"\Uploads\Foods\" + foodId;
            _filesServices.CreateDirectory(folderPath);

            if (isUpdate)
            {
                _filesServices.DeleteAllFile(folderPath);
            }

            var images = new List<FoodsImage>();
            var image = new FoodsImage();

            foreach (var file in files)
            {
                image = new FoodsImage()
                {
                    ImagePath = System.IO.Path.Combine(folderPath, _filesServices.GetRandomFileName() + ".webp"),
                    FoodId = foodId,
                };

                images.Add(image);
                _filesServices.SaveImage(image.ImagePath, file.OpenReadStream());
            }

            return images;
        }

        public List<FoodsSize> FillFoodsSizes(string Sizes, int foodId)
        {
            if (string.IsNullOrEmpty(Sizes))
            {
                return new List<FoodsSize>();
            }

            List<FoodsSize> foodsSizes = JsonConvert.DeserializeObject<List<FoodsSize>>(Sizes);

            for (int i = 0; i < foodsSizes.Count; i++)
            {
                foodsSizes[i].FoodId = foodId;
            }

            return foodsSizes;
        }

        public List<FoodCategory> FillFoodsCategories(string categories, int foodId)
        {
            List<int> categoriesids = JsonConvert.DeserializeObject<List<int>>(categories);
            List<FoodCategory> foodCategories = new List<FoodCategory>();

            for (int i = 0; i < categoriesids.Count; i++)
            {
                foodCategories.Add(new FoodCategory
                {
                    FoodId = foodId,
                    CategoryId = categoriesids[i],
                });
            }

            return foodCategories;
        }
        #endregion

        #region Quearies
        //public string PrepairSqlQueary(DtoFoodSearch search, string otherSql = "")
        //{
        //    string temp = $"SELECT  [Serial],[FoodId],[FoodName],[Price],[Description],[PreparationTime],[UserId],[IsApproved],[IsDelete],[IsActive],[CreationDate],[CookName],[Latitude],[Longitude],[ImagePath],[Rate],[RateCount],[MostPopular],[MostWatched],[Date],{(search.userId == -1 ? "CAST('FALSE' as bit)" : $"[food].[IsFavorite]({search.userId},food.VwFood.FoodId)")} as [IsFavorited] FROM food.VwFood WHERE IsApproved='{search.isApproved}' and ";

        //    if (search.categoryId.Count > 0)
        //    {
        //        if (search.categoryId[0] > 0)
        //        {
        //            temp += $"FoodId in(select FoodId from food.FoodCategories where CategoryId in({string.Join(",", search.categoryId)})) and ";
        //        }
        //    }

        //    if (!string.IsNullOrEmpty(search.foodName))
        //    {
        //        //     temp += $"FoodName like '@0%' and ";
        //        temp += $"FoodName like '" + search.foodName + "%' and ";
        //    }

        //    if (search.priceFrom > -1)
        //    {
        //        temp += $"Price>={search.priceFrom} and ";
        //    }

        //    if (search.priceTo > -1)
        //    {
        //        temp += $"Price<={search.priceTo} and ";
        //    }

        //    if (!string.IsNullOrEmpty(search.latitude) && !string.IsNullOrEmpty(search.longitude))
        //    {
        //        temp += $"food.CalculateDistanceKM(food.VwFood.Latitude, food.VwFood.Longitude,{search.latitude},{search.longitude})<10  and ";
        //    }

        //    temp += otherSql;

        //    return temp.Substring(0, temp.Length - 4); ;
        //}
        public string PrepairSqlQueary(DtoFoodSearch search, string otherSql = "")
        {
            string temp = $"SELECT  [Serial],[FoodId],[FoodName],[Price],[Description],[PreparationTime],[UserId],[IsApproved],[IsDelete],[IsActive],[CreationDate],[CookName],[Cook_ID],[Latitude],[Longitude],[ImagePath],[Rate],[RateCount],[MostPopular],[MostWatched],[Date],{(search.userId == -1 ? "CAST('FALSE' as bit)" : $"[food].[IsFavorite]({search.userId},food.VwFood.FoodId)")} as [IsFavorited] FROM food.VwFood WHERE IsApproved='{search.isApproved}' ";
            
            if (search.categoryId.Count>0)
            {
                if(search.categoryId[0] == 1000)
                {
                    temp += " and " + $"FoodId in(select FoodId " +
                        $"from food.FoodCategories)";
                }
                else if (search.categoryId[0]>0)
                {
                    temp += " and " + $"FoodId in(select FoodId " +
                        $"from food.FoodCategories where CategoryId in({string.Join(",", search.categoryId)})) ";
                } 
            }

            if (!string.IsNullOrEmpty(search.foodName))
            {
                //     temp += $"FoodName like '@0%' and ";
                    temp += " and " + $"FoodName like '"+ search.foodName+ "%' "; 
            }

            if (search.priceFrom > -1)
            {
                temp += " and " + $"Price>={search.priceFrom}  ";
            }

            if (search.priceTo > -1)
            {
                temp += " and " + $"Price<={search.priceTo}  ";
            }

            if (!string.IsNullOrEmpty(search.latitude) && !string.IsNullOrEmpty(search.longitude))
            {
                temp += " and " + $"food.CalculateDistanceKM(food.VwFood.Latitude, food.VwFood.Longitude,{search.latitude},{search.longitude})<10  ";
            }

            temp += otherSql;
            //if(search.categoryId.Count > 0)
            //{
            //    if (search.categoryId[0] != 1000)
            //    {
            //        return temp.Substring(0, temp.Length - 4); ;
            //    }
            //}
            return temp;
        }

        public string PrepairOrder(string Order)
        {
            string sort = string.Empty;

            switch (Order)
            {
                case "price":
                    sort = "Price asc";
                    break;
                case "rate":
                    sort = "Rate desc";
                    break;
                case "mostPopular":
                    sort = "MostPopular desc";
                    break;
                case "mostWatched":
                    sort = "MostWatched desc";
                    break;
                case "preparationTime":
                    sort = "PreparationTime asc";
                    break;
                default:
                    sort = "FoodId desc";
                    break;
            }

            return sort;
        }
        #endregion
    }
}

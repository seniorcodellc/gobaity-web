﻿using System;

namespace YallaBaity.Areas.Api.ViewModel
{
    public class VmFood
    {
        public long? Serial { get; set; }
        public int FoodId { get; set; }
        public string FoodName { get; set; }
        public decimal Price { get; set; }
        public string Description { get; set; }
        public int? PreparationTime { get; set; }
        public int UserId { get; set; }
        public int NumOfPendingFoodOrders { get; set; }
        public int NumOfDeliveredFoodOrders { get; set; }
        public bool IsDelete { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreationDate { get; set; }
        public string CookName { get; set; }
        public int CookId { get; set; }
        public double? Latitude { get; set; }
        public double? Longitude { get; set; }
        public string ImagePath { get; set; }
        public decimal Rate { get; set; }
        public int? RateCount { get; set; }
        public int? MostPopular { get; set; }
        public int? MostWatched { get; set; }
        public int? IsFavorited { get; set; }
        public string Date { get; set; }
    }
}

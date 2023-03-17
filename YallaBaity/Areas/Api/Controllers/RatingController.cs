using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Linq.Dynamic.Core;
using System.Net;
using YallaBaity.Areas.Api.Dto;
using YallaBaity.Areas.Api.Repository;
using YallaBaity.Areas.Api.Services;
using YallaBaity.Areas.Api.ViewModel;
using YallaBaity.Controllers;
using YallaBaity.Models;
using YallaBaity.Resources;

namespace YallaBaity.Areas.Api.Controllers
{
    [Route("api/Users")]
    [ApiController]
    public class RatingController : Controller
    { 
        IBaseRepository<UserRating> _userRating;
        public RatingController(IBaseRepository<UserRating> userRating )
        {
            _userRating = userRating; 
        }

        [HttpPost("{userId}/[controller]")]
        public IActionResult POST(int userId, DtoUserRating model)
        {
            try
            {
                var rating = new UserRating()
                {
                    UserId = userId,
                    Description = model.Description,
                    FoodId = model.FoodId,
                    RatingDate = DateTime.Now,
                    Rating = model.Rating
                };
                 
                _userRating.Add(rating);
                _userRating.Save();

                return Ok(new DtoResponseModel()
                {
                    State = true,
                    Message = AppResource.lbTheOperationWasCompletedSuccessfully,
                    Data = rating
                });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpPut("{userId}/[controller]/{ratingId}")]
        public IActionResult PUT(int userId, DtoUserRating model,int ratingId)
        {
            try
            {
                var rating = _userRating.GetById(ratingId);
                rating.Rating = model.Rating;
                rating.Description= model.Description;
                 
                _userRating.Update(rating);
                _userRating.Save();

                return Ok(new DtoResponseModel()
                {
                    State = true,
                    Message = AppResource.lbTheOperationWasCompletedSuccessfully,
                    Data = rating
                });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }
         
    }
}

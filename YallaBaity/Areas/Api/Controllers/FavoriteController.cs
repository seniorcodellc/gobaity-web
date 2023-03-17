using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualStudio.Web.CodeGeneration.Contracts.Messaging;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Linq.Dynamic.Core;
using System.Net;
using YallaBaity.Areas.Api.Dto;
using YallaBaity.Areas.Api.Enums;
using YallaBaity.Areas.Api.Repository;
using YallaBaity.Areas.Api.Services;
using YallaBaity.Areas.Api.ViewModel;
using YallaBaity.Models;
using YallaBaity.Resources;

namespace YallaBaity.Areas.Api.Controllers
{
    [Route("api/Users")]
    [ApiController]
    public class FavoriteController : Controller
    {
        IBaseRepository<UsersFavorite> _usersLike;
        public FavoriteController(IBaseRepository<UsersFavorite> usersLike)
        {
            _usersLike = usersLike;
        }

        [HttpPost("{userId}/Favorite/{foodId}")]
        public IActionResult PostFavorite(int userId, int foodId)
        {
            try
            {
                bool state = true;

                if (_usersLike.Any(x => x.FoodId == foodId && x.UserId == userId))
                {//UnLike
                    _usersLike.RemoveRange(_usersLike.GetAll(x => x.FoodId == foodId && x.UserId == userId));
                    state = false;
                }
                else
                {//Like
                    _usersLike.Add(new UsersFavorite() { UserId = userId, FoodId = foodId });
                }

                _usersLike.Save();

                return Ok(new DtoResponseModel()
                {
                    State = true,
                    Message = AppResource.lbTheOperationWasCompletedSuccessfully,
                    Data = state
                });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }
    }
}

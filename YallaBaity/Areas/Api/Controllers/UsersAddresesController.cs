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
using System.Globalization;
using System.Linq;
using System.Linq.Dynamic.Core;
using System.Net;
using YallaBaity.Areas.Api.Dto;
using YallaBaity.Areas.Api.Repository;
using YallaBaity.Areas.Api.Services;
using YallaBaity.Areas.Api.ViewModel;
using YallaBaity.Models;
using YallaBaity.Resources;

namespace YallaBaity.Areas.Api.Controllers
{
    [Route("api/Users")]
    [ApiController]
    public class UsersAddresesController : Controller
    {
        IBaseRepository<UsersAddress> _usersAddress;
        IMapper _mapper;
        public UsersAddresesController(IBaseRepository<UsersAddress> usersAddress, IMapper mapper)
        {
            _usersAddress = usersAddress;
            _mapper = mapper;
        }

        [HttpGet("{userId}/[controller]/{usersAddressId}")]
        public IActionResult GET(int userId,int usersAddressId)
        {
            var usersAddress = _usersAddress.Find(x=>x.UsersAddressId== usersAddressId && x.UserId== userId);
            return Ok(new DtoResponseModel() { State = true, Message = "", Data = usersAddress });
        }

        [HttpGet("{userId}/[controller]")]
        public IActionResult GetByUser(int userId)
        {
            var usersAddress = _usersAddress.GetAll(x => x.UserId == userId);
            return Ok(new DtoResponseModel() { State = true, Message = "", Data = usersAddress });
        }

        [HttpDelete("{userId}/[controller]/{usersAddressId}")]
        public IActionResult Delete(int userId, int usersAddressId)
        {
            try
            {
                var usersAddress = _usersAddress.Find(x => x.UsersAddressId == usersAddressId && x.UserId == userId);

                _usersAddress.Remove(usersAddress);
                _usersAddress.Save();
                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = new { } });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbThisRecordIsLinkedToOtherRecords, Data = new { } });
            }
        }

        [HttpPost("{userId}/[controller]")]
        public IActionResult POST(int userId, DtoUsersAddress model)
        {
            try
            {
                UsersAddress usersAddress = _mapper.Map<UsersAddress>(model);
                usersAddress.UserId = userId;

                _usersAddress.Add(usersAddress);
                _usersAddress.Save();

                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = usersAddress });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpPut("{userId}/[controller]/{usersAddressId}")]
        public IActionResult PUT(int userId, DtoUsersAddress model, int usersAddressId)
        {
            try
            {
                var usersAddress = _usersAddress.Find(x => x.UsersAddressId == usersAddressId && x.UserId == userId);

                usersAddress.UsersAddressName = model.UsersAddressName;
                usersAddress.Street = model.Street;
                usersAddress.Address = model.Address;
                usersAddress.ApartmentNo = model.ApartmentNo;
                usersAddress.BuildingNo = model.BuildingNo;
                usersAddress.Floor = model.Floor;
                usersAddress.Latitude = model.Latitude;
                usersAddress.Longitude = model.Longitude;

                _usersAddress.Update(usersAddress);
                _usersAddress.Save();
                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = usersAddress });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }
    }
}

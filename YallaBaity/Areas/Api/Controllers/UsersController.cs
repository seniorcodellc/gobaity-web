using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Linq.Dynamic.Core;
using YallaBaity.Areas.Api.Dto;
using YallaBaity.Areas.Api.Enums;
using YallaBaity.Areas.Api.Repository;
using YallaBaity.Areas.Api.Services;
using YallaBaity.Areas.Api.ViewModel;
using YallaBaity.Models;
using YallaBaity.Resources;

namespace YallaBaity.Areas.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : Controller
    {
        ILinqServices _linqServices;
        IFilesServices _filesServices;
        IUnitOfWork _unitOfWork;
        public UsersController(IUnitOfWork unitOfWork, IFilesServices filesServices, ILinqServices linqServices)
        {
            _unitOfWork = unitOfWork;
            _filesServices = filesServices;
            _linqServices = linqServices;
        }

        [HttpGet("{id}")]
        public IActionResult GET(int id)
        {
            CryptServices services = new CryptServices();

            VwUser vwUser = _unitOfWork.VwUsers.Find(x => x.UserId == id);
            vwUser.Password = services.Decrypt(vwUser.Password);

            return Ok(new DtoResponseModel()
            {
                State = true,
                Message = AppResource.lbTheOperationWasCompletedSuccessfully,
                Data = vwUser,
            });
        }

        [HttpGet]
        public IActionResult GET(int page = 0, int size = 30)
        {
            var providers = _unitOfWork.VwProviders.GetAll().OrderByDescending(x => x.CookId).Skip(page * size).Take(size);
            return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = providers });
        }

        [HttpPost]
        public IActionResult POST([FromForm] DtoUsers model)
        {
            CryptServices services = new CryptServices();
            User user = new User();

            try
            {
                if (_unitOfWork.Users.Any(x => x.Phone == model.Phone))
                    return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbThisPhoneHasAlreadyBeenRegistered, Data = new { } });

                user.UserId = _unitOfWork.Users.NewId(x => x.UserId);
                user.UserName = model.UserName;
                user.Phone = model.Phone;
                user.Gender = model.Gender;
                user.Password = services.Encrypt(model.Password);
                user.IsActive = true;
                user.CreationDate = DateTime.Now;

                string folderPath = "\\Uploads\\Users\\" + user.UserId;

                if (model.Image != null)
                {
                    user.Image = System.IO.Path.Combine(folderPath, _filesServices.GetRandomFileName() + ".webp");
                }

                if (model.NationalIdcard?.Count() == 2)
                {
                    user.Latitude = double.Parse(model.Latitude, CultureInfo.InvariantCulture);
                    user.Longitude = double.Parse(model.Longitude, CultureInfo.InvariantCulture);
                    user.Address = model.Address;
                    user.GovernorateId = model.GovernorateId;
                    user.IsProvider = true;
                    user.IsApproved = false;

                    user.NationalIdcard1 = System.IO.Path.Combine(folderPath, _filesServices.GetRandomFileName() + ".webp");
                    user.NationalIdcard2 = System.IO.Path.Combine(folderPath, _filesServices.GetRandomFileName() + ".webp");
                }


                _unitOfWork.Users.Add(user);
                _unitOfWork.Save();

                _filesServices.CreateDirectory(folderPath);

                if (model.Image != null)
                {
                    _filesServices.SaveImage(user.Image, model.Image.OpenReadStream());
                }

                if (model.NationalIdcard?.Count() == 2)
                {
                    _filesServices.SaveImage(user.NationalIdcard1, model.NationalIdcard[0].OpenReadStream());
                    _filesServices.SaveImage(user.NationalIdcard2, model.NationalIdcard[1].OpenReadStream());
                }

                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = user });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpPut("{userId}")]
        public IActionResult PUT(int userId, [FromForm] DtoUpdateUsers model)
        {
            CryptServices services = new CryptServices();
            User user = _unitOfWork.Users.GetById(userId);
            string OldImage = string.Empty, OldNationalIdcard1 = string.Empty, OldNationalIdcard2 = string.Empty;

            try
            {
                user.Gender = model.Gender;
                user.UserName = model.UserName;

                string folderPath = "\\Uploads\\Users\\" + userId;

                if (model.Image != null)
                {
                    OldImage = user.Image;
                    user.Image = System.IO.Path.Combine(folderPath, _filesServices.GetRandomFileName() + ".webp");
                }

                if (user.IsProvider)
                {

                    user.Latitude = double.Parse(model.Latitude, CultureInfo.InvariantCulture);
                    user.Longitude = double.Parse(model.Longitude, CultureInfo.InvariantCulture);
                    user.Address = model.Address;
                    user.GovernorateId = model.GovernorateId;

                    if (model.NationalIdcard?.Count() == 2)
                    {
                        OldNationalIdcard1 = user.NationalIdcard1;
                        OldNationalIdcard2 = user.NationalIdcard2;

                        user.NationalIdcard1 = System.IO.Path.Combine(folderPath, _filesServices.GetRandomFileName() + ".webp");
                        user.NationalIdcard2 = System.IO.Path.Combine(folderPath, _filesServices.GetRandomFileName() + ".webp");
                        user.IsApproved = false;
                    }
                }

                _unitOfWork.Users.Update(user);
                _unitOfWork.Save();

                _filesServices.CreateDirectory(folderPath);


                if (model.Image != null)
                {
                    _filesServices.DeleteFile(OldImage);
                    _filesServices.SaveImage(user.Image, model.Image.OpenReadStream());
                }

                if (model.NationalIdcard?.Count() == 2)
                {
                    _filesServices.DeleteFile(OldNationalIdcard1);
                    _filesServices.DeleteFile(OldNationalIdcard2);

                    _filesServices.SaveImage(user.NationalIdcard1, model.NationalIdcard[0].OpenReadStream());
                    _filesServices.SaveImage(user.NationalIdcard2, model.NationalIdcard[1].OpenReadStream());
                }

                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = user });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel()
                {
                    State = false,
                    Message = AppResource.lbError,
                    Data = new { }
                });
            }
        }

        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            try
            {
                User user = _unitOfWork.Users.GetById(id);
                user.IsDelete = true;

                _unitOfWork.Users.Update(user);
                _unitOfWork.Save();

                _filesServices.DeleteFile(user.Image);
                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = new { } });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpPut("[action]/{userId}")]
        public IActionResult UpdateLatLng(int userId, DtoLatLng dtoLatLng)
        {
            try
            {
                User user = _unitOfWork.Users.GetById(userId);
                user.Latitude = dtoLatLng.Latitude;
                user.Longitude = dtoLatLng.Longitude;

                _unitOfWork.Users.Update(user);
                _unitOfWork.Save();
                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = user });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel()
                {
                    State = false,
                    Message = AppResource.lbError,
                    Data = new { }
                });
            }
        }

        [HttpPut("[action]/{userId}")]
        public IActionResult ChangePassword(int userId, DtoChangePassword dtoChangePassword)
        {
            try
            {
                CryptServices crypt = new CryptServices();
                User user = _unitOfWork.Users.GetById(userId);

                if (!crypt.Verify(dtoChangePassword.OldPassword, user.Password))
                {
                    return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbThePasswordIsIncorrect, Data = new { } });
                }

                user.Password = crypt.Encrypt(dtoChangePassword.NewPassword);

                _unitOfWork.Users.Update(user);
                _unitOfWork.Save();
                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = new { } });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel()
                {
                    State = false,
                    Message = AppResource.lbError,
                    Data = new { }
                });
            }
        }

        [HttpPut("[action]/{userId}")]
        public IActionResult SetPassword(int userId, DtoChangePassword dtoChangePassword)
        {
            try
            {
                CryptServices crypt = new CryptServices();

                User user = _unitOfWork.Users.GetById(userId);
                user.Password = crypt.Encrypt(dtoChangePassword.Password);

                _unitOfWork.Users.Update(user);
                _unitOfWork.Save();
                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = new { } });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel()
                {
                    State = false,
                    Message = AppResource.lbError,
                    Data = new { }
                });
            }
        }

        [HttpPut("[action]/{userId}")]
        public IActionResult ApproveProvider(int userId)
        {
            User user = _unitOfWork.Users.GetById(userId);
            user.IsApproved = true;

            if (user.IsProvider != true)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbThisUserIsNotAProvider, Data = new { } });
            }

            _unitOfWork.Users.Update(user);
            _unitOfWork.Save();

            return Ok(new DtoResponseModel()
            {
                State = true,
                Message = AppResource.lbTheOperationWasCompletedSuccessfully,
                Data = new { },
            });
        }

        [HttpPut("[action]/{userId}")]
        public IActionResult SetUserToProvider(int userId, [FromForm] DtoProviter model)
        {
            try
            {

                User user = _unitOfWork.Users.GetById(userId);
                user.Latitude = double.Parse(model.Latitude, CultureInfo.InvariantCulture);
                user.Longitude = double.Parse(model.Longitude, CultureInfo.InvariantCulture);
                user.Address = model.Address;
                user.GovernorateId = model.GovernorateId;
                user.IsProvider = true;
                user.IsApproved = false;

                var folderPath = "\\Uploads\\Users\\" + userId;


                if (model.NationalIdcard?.Count() == 2)
                {
                    _filesServices.CreateDirectory(folderPath);

                    user.NationalIdcard1 = System.IO.Path.Combine(folderPath, _filesServices.GetRandomFileName() + ".webp");
                    user.NationalIdcard2 = System.IO.Path.Combine(folderPath, _filesServices.GetRandomFileName() + ".webp");

                    _filesServices.SaveImage(user.NationalIdcard1, model.NationalIdcard[0].OpenReadStream());
                    _filesServices.SaveImage(user.NationalIdcard2, model.NationalIdcard[1].OpenReadStream());
                }
                else
                {
                    return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbPleaseCompleteTheInformation, Data = new { } });
                }

                _unitOfWork.Users.Update(user);
                _unitOfWork.Save();

                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = user });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpPost("[action]/{userId}")]
        public IActionResult SendOTP(int userId, string userPhone = "")
        {
            try
            {
                User user;
                if (string.IsNullOrEmpty(userPhone))
                {//userId
                    user = _unitOfWork.Users.GetById(userId);
                }
                else
                {//userPhone 
                    if (_unitOfWork.Users.Any(x => x.Phone == userPhone))
                    {
                        user = _unitOfWork.Users.Find(x => x.Phone == userPhone);
                    }
                    else
                    {
                        return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbThisPhoneIsNotRegistered, Data = new { } });
                    }
                }

                //new Random().Next(1000, 9999);
                int otpCode = 1234;

                TimeSpan LastSent = DateTime.Now - (user.OtpdateOfLastSent ?? DateTime.Now);

                if (LastSent.Days > 0)
                {
                    user.OtpnumberOfTimesSent = 0;
                }

                if (LastSent.Days == 0 && user.OtpnumberOfTimesSent > 2)
                {
                    return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbYouHaveExceededTheMaximumNumberOfDailySubmissions, Data = new { } });
                }
                else
                {
                    //here Send Api On Succss compleate
                    user.OtpdateOfLastSent = DateTime.Now;
                    user.Otpcode = otpCode;
                    user.OtpnumberOfTimesSent = (user.OtpnumberOfTimesSent ?? 0) + 1;

                    _unitOfWork.Users.Update(user);
                    _unitOfWork.Save();
                }

                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = user });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpPost("[action]")]
        public IActionResult SendOTP(string userPhone)
        {
            try
            {
                int otpCode = new Random().Next(1000, 9999);

                return Ok(new DtoResponseModel()
                {
                    State = true,
                    Message = AppResource.lbTheOperationWasCompletedSuccessfully,
                    Data = otpCode
                });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpPost("[action]/{userId}")]
        public IActionResult CheckOTP(int userId, int code, bool login = false)
        {
            try
            {
                var users = _unitOfWork.Users.GetAll(x => x.UserId == userId).ToList();
                if (users.Count() > 0)
                {
                    if (users[0].Otpcode == code)
                    {
                        users[0].Otpcode = 0;

                        _unitOfWork.Users.Update(users[0]);
                        _unitOfWork.Save();

                        if (login)
                        {
                            Security.SecurityManager securityManager = new Security.SecurityManager();
                            securityManager.SideSignin(this.HttpContext, users[0]);
                            Response.Cookies.Append("userId", users[0].UserId.ToString());
                        }

                        return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbWelcome, Data = users[0] });
                    }
                }

                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbTheOTPNumberIsIncorrect, Data = new { } });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpPost("[action]")]
        public IActionResult Login(DtoLogin login)
        {
            try
            {
                IEnumerable<User> users = _unitOfWork.Users.GetAll(x => x.Phone == login.Phone);

                if (users.Count() > 0)
                {
                    CryptServices crypt = new CryptServices();

                    User user = users.FirstOrDefault();
                    if (!user.IsActive || user.IsDelete)
                    {
                        return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbThisAccountIsInactive, Data = new { } });
                    }
                    else if (!crypt.Verify(login.Password, user.Password))
                    {
                        return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbThePasswordIsIncorrect, Data = new { } });
                    }
                    //else if (user.Otpactive == false)
                    //{
                    //    return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbPleaseConfirmTheOTPCode, Data = new { } });
                    //}
                    else
                    {
                        Security.SecurityManager securityManager = new Security.SecurityManager();
                        securityManager.SideSignin(this.HttpContext, user);
                        Response.Cookies.Append("userId", user.UserId.ToString());

                        user.Password = login.Password;
                        return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbWelcome + " " + user.UserName, Data = user });
                    }
                }
                else
                {
                    return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbPleaseSignIn, Data = new { } });
                }
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel()
                {
                    State = false,
                    Message = AppResource.lbError,
                    Data = new { }
                });
            }
        }

        [HttpPut("[action]/{id}")]
        public IActionResult Active(int id)
        {
            try
            {
                var user = _unitOfWork.Users.GetById(id);
                user.IsActive = !user.IsActive;

                _unitOfWork.Users.Update(user);
                _unitOfWork.Save();
                return Ok(new DtoResponseModel() { State = true, Message = AppResource.lbTheOperationWasCompletedSuccessfully, Data = user.IsActive });
            }
            catch (Exception)
            {
                return Ok(new DtoResponseModel() { State = false, Message = AppResource.lbError, Data = new { } });
            }
        }

        [HttpPost("[action]")]
        public IActionResult LoadDataTable([FromForm] VmDataTable vmDataTable, UsersType usersType)
        {
            string baseQueary = $"IsDelete=false and ";

            switch (usersType)
            {
                case UsersType.users:
                    baseQueary += "IsProvider=false";
                    break;
                case UsersType.proviters:
                    baseQueary += "IsProvider=true and IsApproved=true";
                    break;
                case UsersType.pending:
                    baseQueary += "IsProvider = true and IsApproved =false";
                    break;
                default:
                    break;
            }

            int totalResultsCount = _unitOfWork.VwUsers.Count(baseQueary);
            int filteredResultsCount = 0;
            var query = _linqServices.GenerateQuery<VwUser>("UserId,UserName,Phone,GovernorateAname,GovernorateEname");

            IQueryable<VwUser> source;

            if (!string.IsNullOrEmpty(vmDataTable.search.value))
            {
                source = _unitOfWork.VwUsers.GetAll((" " + vmDataTable.columns[vmDataTable.order[0].column].name + " " + vmDataTable.order[0].dir), query + " and " + baseQueary, vmDataTable.search.value).Skip(vmDataTable.start).Take(vmDataTable.length);
                filteredResultsCount = _unitOfWork.VwUsers.Count(query + " and " + baseQueary, vmDataTable.search.value);
            }
            else
            {
                source = _unitOfWork.VwUsers.GetAll((" " + vmDataTable.columns[vmDataTable.order[0].column].name + " " + vmDataTable.order[0].dir), baseQueary).Skip(vmDataTable.start).Take(vmDataTable.length);
                filteredResultsCount = totalResultsCount;
            }

            return Ok(new
            {
                data = source,
                draw = vmDataTable.draw,
                recordsTotal = totalResultsCount,
                recordsFiltered = filteredResultsCount
            });
        }
    }
}
using Microsoft.AspNetCore.Mvc;
using YallaBaity.Areas.Api.Dto;
using YallaBaity.Areas.Api.Repository;
using YallaBaity.Models;
using System.Linq;

namespace YallaBaity.Areas.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class WalletController : ControllerBase
    {
        IUnitOfWork _unitOfWork;
        public WalletController(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        [HttpGet("{userId}")]
        public IActionResult GET(int userId)
        {
            decimal walletValue = 0;
            if (_unitOfWork.Wallets.Any(x => x.UserId == userId))
            {
                walletValue = _unitOfWork.Wallets.GetAll(x => x.UserId == userId).FirstOrDefault().Balance;
            }

            return Ok(new DtoResponseModel() { State = true, Message = "", Data = walletValue });
        }


        [HttpGet]
        public IActionResult GET(int userId, int page = 0, int size = 30)
        {
            decimal walletValue = 0;
            if (_unitOfWork.Wallets.Any(x => x.UserId == userId))
            {
                walletValue = _unitOfWork.Wallets.GetAll(x => x.UserId == userId).FirstOrDefault().Balance;
            }


            return Ok(new DtoResponseModel()
            {
                State = true,
                Message = "",
                Data = new
                {
                    Balance = walletValue,
                    History = _unitOfWork.VwWalletHistories.GetAll(x => x.UserId == userId)
                }
            });
        }


        [HttpPut("{userId}")]
        public IActionResult Put(int userId, decimal amount, int effect)
        {
            Wallet wallet;
            bool isExist = _unitOfWork.Wallets.Any(x => x.UserId == userId);
            WalletHistory walletHistory = new WalletHistory();
            walletHistory.Effect = effect;
            walletHistory.UserId = userId;
            walletHistory.Amount = amount;
            walletHistory.Date = System.DateTime.Now;

            if (isExist)
            {
                wallet = _unitOfWork.Wallets.GetAll(x => x.UserId == userId).FirstOrDefault();
            }
            else
            {
                wallet = new Wallet() { UserId = userId, Balance = 0 };
            }

            if (effect == -1)
                wallet.Balance = wallet.Balance - amount;
            else
                wallet.Balance = wallet.Balance + amount;

            walletHistory.Balance = wallet.Balance;

            if (!isExist)
                _unitOfWork.Wallets.Add(wallet);
            else
                _unitOfWork.Wallets.Update(wallet);

            _unitOfWork.WalletHistories.Add(walletHistory);
            _unitOfWork.Save();

            return Ok(new DtoResponseModel() { State = true, Message = "", Data = wallet.Balance });
        }
    }
}

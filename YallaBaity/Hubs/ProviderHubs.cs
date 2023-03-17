using Microsoft.AspNetCore.SignalR;
using System.Threading.Tasks;

namespace YallaBaity.SignalrHubs
{
    public class ProviderHubs : Hub
    {
        public async void orderCount(int count)
        {
            await Clients.All.SendAsync("orderCountValue", count);
        }
    }
}

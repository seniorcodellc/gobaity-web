using Microsoft.AspNetCore.SignalR;
using System.Threading.Tasks;

namespace YallaBaity.SignalrHubs
{
    public class ProviderHubs : Hub
    {
        public async void orderCount(int count, int providerId)
        {
            await Clients.All.SendAsync("orderCountValue", count, providerId);
        }
    }
}

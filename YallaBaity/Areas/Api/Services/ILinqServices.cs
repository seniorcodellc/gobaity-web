namespace YallaBaity.Areas.Api.Services
{
    public interface ILinqServices
    {
        string GenerateQuery<T>(string includes = "",string additions="");
        public T GetDefaultIsEmpty<T>(int id) where T : class;
    }
}

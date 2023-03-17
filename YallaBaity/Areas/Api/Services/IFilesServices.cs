using ImageProcessor.Plugins.WebP.Imaging.Formats;
using ImageProcessor;
using static ImageProcessor.Web.Configuration.ImageSecuritySection;
using System.IO;

namespace YallaBaity.Areas.Api.Services
{
    public interface IFilesServices
    {
        string GetRandomFileName();
        void CreateDirectory(string path);
        void DeleteFile(string path);
        void DeleteAllFile(string folderPath);
        void SaveImage(string path, Stream stream, int quality = 100);
    }
}

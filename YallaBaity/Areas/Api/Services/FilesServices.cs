using ImageProcessor.Plugins.WebP.Imaging.Formats;
using ImageProcessor;
using System.IO;
using System.Drawing;
using static System.Net.Mime.MediaTypeNames;
using Microsoft.AspNetCore.Hosting;

namespace YallaBaity.Areas.Api.Services
{
    public class FilesServices : IFilesServices
    {
        IWebHostEnvironment _webHostEnvironment;
        public FilesServices(IWebHostEnvironment webHostEnvironment)
        {
            this._webHostEnvironment = webHostEnvironment;
        }
        public string GetRandomFileName()
        {
            return System.IO.Path.GetRandomFileName();
        }
        public void CreateDirectory(string path)
        {
            if (!Directory.Exists(_webHostEnvironment.WebRootPath + path))
            {
                Directory.CreateDirectory(_webHostEnvironment.WebRootPath + path);
            }
        }
        public void DeleteFile(string path)
        {
            if (File.Exists(_webHostEnvironment.WebRootPath + path))
            {
                File.Delete(_webHostEnvironment.WebRootPath + path);
            }
        }
        public void DeleteAllFile(string folderPath)
        {
            string[] files = Directory.GetFiles(_webHostEnvironment.WebRootPath + folderPath);

            foreach (string file in files)
            {
                if (File.Exists(file))
                {
                    File.Delete(file);
                }
            }
        }
        public void SaveImage(string path, Stream stream,int quality=100)
        {
            using (var webPFileStream = new FileStream(_webHostEnvironment.WebRootPath + path, FileMode.Create))
            {
                using (ImageFactory imageFactory = new ImageFactory(preserveExifData: false))
                {
                    imageFactory.Load(stream).Format(new WebPFormat()).Quality(quality).Save(webPFileStream);
                }
            }
        }
    }
}

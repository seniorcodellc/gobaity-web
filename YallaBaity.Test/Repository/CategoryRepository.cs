using ImageProcessor.Imaging.Helpers;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using YallaBaity.Models;

namespace YallaBaity.Test.Repository
{
    public class CategoryRepository
    {
        private async Task<YallaBaityDBContext> GetDbContext()
        {
            var Options = new DbContextOptionsBuilder<YallaBaityDBContext>().UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString()).Options;
            var databasecontext = new YallaBaityDBContext(Options);
            databasecontext.Database.EnsureCreated();
            if (await databasecontext.Categories.CountAsync() <= 0)
            {
                for (int i = 0; i < 10; i++)
                {
                    databasecontext.Categories.Add(new Category()
                    {
                        ImagePath = Guid.NewGuid().ToString(),
                        CategoryEname = Guid.NewGuid().ToString(),
                        CategoryAname = Guid.NewGuid().ToString(),
                        CategoryId = i + 50,
                        BackgroundColor = 000,
                    });

                    await databasecontext.SaveChangesAsync();
                }
            }

            return databasecontext;
        }

        [Fact]
        public async void CategoryRepository_Add_ReturnsBool()
        {
            //Arrange
            var categorys = new Category()
            {
                ImagePath = Guid.NewGuid().ToString(),
                CategoryEname = Guid.NewGuid().ToString(),
                CategoryAname = Guid.NewGuid().ToString(),
                CategoryId = 555,
                BackgroundColor = 000,
            };

            var dbcontext = await GetDbContext();
            var categorysRepository = new BaseRepository<Category>(dbcontext);

            //Act
            categorysRepository.Add(categorys);
            var result = categorysRepository.Save();

            //Assert
            result.Should().BeTrue();
        }

        [Fact]
        public async void CategoryRepository_Update_ReturnsBool()
        {
            //Arrange
            var dbcontext = await GetDbContext();

            Category categorys = dbcontext.Categories.LastOrDefault() ?? new Category();
            categorys.ImagePath = "/ImagePath";
            categorys.CategoryEname = "Category English name";
            categorys.CategoryAname = "Category Arabic name";
            categorys.BackgroundColor = 000;
            categorys.IsActive = true;
            categorys.IsDelete = true;

            var categorysRepository = new BaseRepository<Category>(dbcontext);

            //Act

            categorysRepository.Update(categorys);
            var result = categorysRepository.Save();

            //Assert
            result.Should().BeTrue();
        }

        [Fact]
        public async void CategoryRepository_Delete_ReturnsBool()
        {
            //Arrange 
            var dbcontext = await GetDbContext();
            var categorysRepository = new BaseRepository<Category>(dbcontext);

            //Act
            categorysRepository.Remove(51);
            var result = categorysRepository.Save();

            //Assert
            result.Should().BeTrue();
        }
    }

}

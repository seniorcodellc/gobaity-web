

using AutoMapper;
using FakeItEasy;
using Microsoft.AspNetCore.Http;
using YallaBaity.Areas.Api.Dto;
using YallaBaity.Models;

namespace YallaBaity.Test.ApiTests
{
    public class CategorysTests
    {
        private readonly IBaseRepository<Category> _categoryRepository;
        private readonly IBaseRepository<VwCategory> _vwCategoryRepository;
        private readonly IBaseRepository<VwFoodCategory> _vwFoodCategory;
        private readonly ILinqServices _linqServices;
        private readonly IFilesServices _filesServices;
        private readonly IMapper _mapper;
        private CategoriesController _categorysController;
        public CategorysTests()
        {
            _categoryRepository = A.Fake<IBaseRepository<Category>>();
            _vwCategoryRepository = A.Fake<IBaseRepository<VwCategory>>();
            _vwFoodCategory = A.Fake<IBaseRepository<VwFoodCategory>>();
            _linqServices = A.Fake<ILinqServices>();
            _filesServices = A.Fake<IFilesServices>();
            _mapper = A.Fake<IMapper>();

            _categorysController = new CategoriesController(_categoryRepository, _vwCategoryRepository,  _linqServices, _vwFoodCategory, _filesServices, _mapper);
        }

        [Fact]
        public void CategorysTests_GetAll_RetuensSuccess()
        {
            //Arrange  
            var category = A.Fake<IQueryable<Category>>();
            var vwCategory = A.Fake<IQueryable<VwCategory>>();

            A.CallTo(() => _categoryRepository.GetAll()).Returns(category);
            A.CallTo(() => _vwCategoryRepository.GetAll()).Returns(vwCategory);

            //Act
            var result = _categorysController.GET();

            //Assert
            result.Should().BeOfType<OkObjectResult>();
        }

        [Fact]
        public void CategorysTests_GetById_RetuensSuccess()
        {
            //Arrange  
            var category = A.Fake<IQueryable<Category>>();
            var vwCategory = A.Fake<IQueryable<VwCategory>>();

            A.CallTo(() => _categoryRepository.GetAll()).Returns(category);
            A.CallTo(() => _vwCategoryRepository.GetAll()).Returns(vwCategory);

            //Act
            var result = _categorysController.GET(1);

            //Assert
            result.Should().BeOfType<OkObjectResult>();
        }

        [Fact]
        public void CategorysTests_Delete_RetuensSuccess()
        {
            //Arrange   

            //Act
            var result = _categorysController.Delete(1);

            //Assert
            result.Should().BeOfType<OkObjectResult>();
        }

        [Fact]
        public void CategorysTests_Active_RetuensSuccess()
        {
            //Arrange   

            //Act
            var result = _categorysController.Active(1);

            //Assert
            result.Should().BeOfType<OkObjectResult>();
        }

        [Fact]
        public void CategorysTests_Add_RetuensSuccess()
        {
            //Arrange
            var testFilePath = "4jupvhkv.v4v.webp";
            var testFileBytes = File.ReadAllBytes(testFilePath);
            var ms = new MemoryStream(testFileBytes);
            IFormFile fromFile = new FormFile(ms, 0, ms.Length, Path.GetFileNameWithoutExtension(testFilePath), Path.GetFileName(testFilePath));

            object value;
            DtoCategoriesForm category = new DtoCategoriesForm()
            {
                CategoryAname = "category arabic name",
                CategoryEname = "category english name",
                Image = fromFile,
                BackgroundColor = 000,
                CategoryAdescription = "",
                CategoryEdescription = "", IsActive= true,
            };

            A.CallTo(() => _filesServices.GetRandomFileName()).Returns("RandomFileName");

            //Act
            var result = _categorysController.POST(category);
            value = ((OkObjectResult)result).Value ?? "";

            //Assert
            result.Should().BeOfType<OkObjectResult>();
            value.GetType().GetProperty("State")?.GetValue(value).Should().Be(true);
        }
    }
}

 namespace YallaBaity.Test.ApiTests
{ 
    public class AdsTests
    {
        private readonly IBaseRepository<Ad> _adsRepository;
        private AdsController _adsController;
        public AdsTests()
        {
            _adsRepository = A.Fake<IBaseRepository<Ad>>();
            _adsController = new AdsController(_adsRepository);
        }

        [Fact]
        public void AdsTests_GetAll_RetuensSuccess()
        {
            //Arrange  
            var ads = A.Fake<IQueryable<Ad>>();
            A.CallTo(() => _adsRepository.GetAll()).Returns(ads);

            //Act
            var result = _adsController.GET();

            //Assert
            result.Should().BeOfType<OkObjectResult>(); 

        }
    }
}

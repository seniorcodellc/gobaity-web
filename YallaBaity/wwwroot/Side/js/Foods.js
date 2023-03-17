var categoryId = ($('#categoryId').val() == 0 || $('#categoryId').val() == undefined) ? -1 : $('#categoryId').val();
var search = "";
var order = "";
var latitude = "";
var longitude = "";
var userId = -1;
var page = 0;
var size = 15;
var providerId = $('#providerId').val();
 
$('#txtSearch').keyup(function () {
    search = $(this).val();
    page = 0;
    LoadData();
})

$('#SearchSortingContainer .SortItem').click(function () {
    $("#SearchSortingContainer .SortItem.active").removeClass('active');
    $(this).addClass("active");
    order = $(this).attr('data-value');
    page = 0;
    LoadData();
});

$('.PageNext').click(function () {
    if ($('#FoodsList .FoodsItem').length == size) {
        page = page + 1;
        location.href = '#SearchSortingContainer';
        LoadData();
    }
})

$('.PageBack').click(function () {
    if (page > 0) {
        page = page - 1;
        location.href = '#SearchSortingContainer';
        LoadData();
    }
})

function LoadData() {
    Ajax.GET(`/api/Foods${(providerId == 0 ? `?` : `/Provider?providerId=${providerId}&`)}page=${page}&size=${size}&categoryId=${categoryId}&userId=${userId}&priceFrom=-1&priceTo=-1&foodName=${search}&order=${order}&latitude=${latitude}&longitude=${longitude}`, {}, (data) => {
        $('#FoodsList').empty();
        $('#txtPageNumber').text('page ' + (page + 1));

        $.each(data.data, function (index, row) {
            $('#FoodsList').append(TemplatesHTML.FoodItemHTML(row.imagePath, row.foodId, row.foodName, row.userId, row.cookName, row.rate, row.preparationTime, row.price));
        })
    }, () => { Alert.Error() });
}

$(function () {
    let lat = localStorage.getItem('lat');
    let lng = localStorage.getItem('lng');
    let address = localStorage.getItem('address');

    if (lat != null && lng != null) {
        latitude = lat;
        longitude = lng;
    }

    if (address != null) {
        $('#txtDeliveryto').text(address);
    }

    let UId = $('#userId').val();
    if (UId != '') {
        userId = UId;
    }
     
    Ajax.GET((providerId == 0 ? "/api/Categories" : ("/api/Categories/GetUsedByProvider/" + providerId)), {}, (data) => {
        $.each(data.data, function (index, row) {
            $('#CategoriesFilter').append(TemplatesHTML.CategoriesFilterHTML(row.categoryId, row.categoryName));
        })

        $('#CategoriesFilter li[data-value="' + categoryId + '"]').addClass('active');

        $("#CategoriesFilter li").click(function () {
            $("#CategoriesFilter li.active").removeClass('active');
            $(this).addClass("active");
            categoryId = $(this).attr('data-value');
            page = 0;
            LoadData();
        });
    }, () => { Alert.Error() });

    LoadData();
})
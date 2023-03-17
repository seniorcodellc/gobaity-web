var OnLoadCategories = () => { };

var TemplatesHTML = {
    NavBarCategoriesHTML: function (categoryId, categoryName, categoryImage) {
        return '<a href="/Foods/' + categoryId + '/' + categoryName + '"><div><img src="' + categoryImage + '" class="img-responsive" /><h6>' + categoryName + '</h6></div></a> ';
    },
    FooterCategoriesHTML: function (categoryId, categoryName) {
        return '<li><a href="/Foods/' + categoryId + '/' + categoryName + '"> ' + categoryName + '</a></li>';
    },
    CategoriesFilterHTML: function (categoryId, categoryName) {
        return '<li data-value="' + categoryId + '">' + categoryName + '</li>';
    },
    FoodItemHTML: function (img, foodId, foodName, proviterId, proviterName, rating, time, price = 0, controls = '') {
        return '<div class="FoodsItem"><div class="row"><div class="col-md-3 col-sm-12 col-12 text-center"><a href="/Foods/Details/' + foodId + '/' + foodName + '">  <img src="' + img + '" class="img-responsive" /></a></div><div class="col-md-9 col-sm-12 col-12"><div class="food-form"><h4 class="food-title"><a href="/Foods/Details/' + foodId + '/' + foodName + '">' + foodName + '</a><span>' + price + 'ج.م</span>' + controls + '</h4><p><a href="/Foods/ProviterFoods/' + proviterId + '/' + proviterName + '">' + proviterName + '</a></p><div class="row"><div class="col-5 col-sm-4"><div><span><i class="fas fa-truck"></i>&nbsp;' + time + ' ' + language("minute") + '</span></div></div><div class="col-2 col-sm-1"><div><span>|</span></div></div><div class="col-5 col-sm-4"><div><span><i class="fas fa-star"></i>&nbsp;' + (rating == null ? 0 : rating) + '</span></div></div><div class="col-12 col-sm-3"><div><a href="/Foods/Details/' + foodId + '/' + foodName + '">' + language("orderNow") + '</a> &nbsp;<i class="fas fa-angle-right"></i></div></div></div></div></div></div></div>';
    },
    FoodCartHTML: function (img, foodId, foodName, proviterId, proviterName, rating, time, qty, price, sizeName, foodsSizesId, basketId) {
        return ' <div class="FoodsItem"><div class="row"><div class="col-md-3 col-sm-12 col-12 text-center"><a href="/Foods/Details/' + foodId + '/' + foodName + '">  <img src="' + img + '" class="img-responsive" /></a></div><div class="col-md-9 col-sm-12 col-12"><div class="food-form"><h4 class="food-title"><a href="/Foods/Details/' + foodId + '/' + foodName + '"> ' + foodName + ' (' + sizeName + ')</a><span>' + price + 'ج.م</span> </h4><p><a href="/Foods/ProviterFoods/' + proviterId + '/' + proviterName + '">' + proviterName + '</a></p><div class="row"><div class="col-5 col-sm-4"><div><span><i class="fas fa-truck"></i>&nbsp;' + time + ' ' + language("minute") + '</span></div></div><div class="col-2 col-sm-1"><div><span>|</span></div></div><div class="col-5 col-sm-4"><div><span><i class="fas fa-star"></i>&nbsp;' + (rating == null ? 0 : rating) + '</span></div></div><div class="col-6 col-sm-6"><div class="Qty-container"><button class="active max">+</button><input class="num" type="text" min="1" value="' + qty + '" data-basketId="' + basketId + '" data-foodsSizesId="' + foodsSizesId + '" readonly value="0" /><button class="min">-</button></div></div><div class="col-6 col-sm-6"><div><button class="Cart-Remove" data-basketId="' + basketId + '" data-foodsSizesId="' + foodsSizesId + '">' + language("delete") + ' <i class="fas fa-times"></i></button></div></div></div></div></div></div></div>';
    },
    FoodCartCheckOutHTML: function (img, foodId, foodName, proviterId, proviterName, rating, time, qty, price, sizeName, foodsSizesId, basketId) {
        return ' <div><div><p>' + foodName + '</p><div class="Qty-container"><button class="active max">+</button><input class="num" type="text" min="1" value="' + qty + '" data-basketid="' + basketId + '" data-foodssizesid="' + foodsSizesId + '" readonly=""><button class="min">-</button></div></div><div><h5>' + price + '</h5> <button class="Cart-Remove" data-basketid="' + basketId + '" data-foodssizesid="' + foodsSizesId + '">' + language("delete") +' <i class="fas fa-times"></i></button></div></div>';
    },
    OrderHead: function (orderId, orderCode, orderDate, deliveryCost, total, net, orderState) {
        return ' <div class="OrderHead"><div> <div><b>' + language("date") + ':</b>' + orderDate + '</div><div><a href="/Orders/' + orderId + '">' + language("details") + '</a></div></div><div><div>#' + orderCode + '</div><div><b>' + language("delivery") + ':</b>' + deliveryCost + '</div><div><b>' + language("total") + ':</b>' + total + '</div><div><b>' + language("net") +':</b>' + net + '</div><div><b>' + orderState + '</b></div></div></div>';
    },
    OrderFoodItem: function (foodId, foodName, proviterId, proviterName, image, size, qty, price) {
        return '<div class="FoodsItem"><div class="row"><div class="col-md-3 col-sm-12 col-12 text-center"><a href="/Foods/Details/' + foodId + '/' + foodName + '"><img src="' + image + '" class="img-responsive"></a></div><div class="col-md-9 col-sm-12 col-12"><div class="food-form"><h4 class="food-title"><a href="/Foods/Details/' + foodId + '/' + foodName + '">' + foodName + '</a> </h4><p><a href="/Foods/ProviterFoods/' + proviterId + '/' + proviterName + '">' + proviterName + '</a></p><div class="row"><div class="col-4 col-sm-4"><div><span><b>' + language("price") +':</b>' + price + '</span></div></div> <div class="col-4 col-sm-4"><div><span><b>' + language("quantity") + ':</b>' + qty + '</span></div></div><div class="col-4 col-sm-4"><div><span><b>' + language("size") +':</b>' + size + '</span></div></div></div></div></div></div></div>';
    },
    AdsHTML: function (img) {
        return '<div class="item container"><img src="' + img + '" /></div>'
    },
    ReviewHTML: function (userName, ratingDate, description, rating) {
        let stars = '';
        for (var i = 0; i < rating; i++)
            stars += '<i class="fas fa-star"></i>';

        return '<div class="ReviewItem"><div><h3>' + userName + '</h3><p>' + ratingDate + '</p></div><p>' + description + '</p><div class="StarsContainer">' + stars + '</div></div>';
    },
    SizesHTML: function (foodsSizesId, name, description) {
        return '  <div><h3>' + name + '</h3><p>' + description + '</p><div class="Qty-container"><button class="active max">+</button><input class="num SizeItem" min="0" data-foodsSizesId="' + foodsSizesId + '" type="text" readonly   value="0" /><button class="min">-</button></div></div>';
    }
};

//Cart Quantity
function CartQuantityEvent() {
    $('.Qty-container .max').click(function () {
        let txtNumber = $(this).parents('.Qty-container').children('.num');
        txtNumber.val(+txtNumber.val() + 1);
    })

    $('.Qty-container .min').click(function () {
        let txtNumber = $(this).parents('.Qty-container').children('.num');
        if (txtNumber.val() > txtNumber.attr('min')) {
            txtNumber.val(+txtNumber.val() - 1);
        }
    })
}

//FoodSlider
function FoodSliderEvent() {
    $('.FoodSlider-Container img').click(function () {
        let selectedImage = $('#FoodSliderSelectedImage').attr('src');
        let thisImage = $(this).attr('src');

        $(this).attr('src', selectedImage);
        $('#FoodSliderSelectedImage').attr('src', thisImage);
    })
}

//RadioButton
function RadioButtonEvent() {
    $('.RadioButton span').click(function () {
        if (!$(this).hasClass('active')) {
            let radioId = $(this).attr('data-for');
            let radioName = $(this).attr('data-name-for');

            $('.RadioButton input[name="' + radioName + '"]').prop('checked', false);
            $('#' + radioId).prop('checked', true);

            $(this).addClass('active');
            $('.RadioButton span[data-name-for="' + radioName + '"]').not(this).removeClass('active');
        }
    })
}

$(document).ready(function () {
    if ($('.Banner .owl-carousel').length > 0) {
        var owl = $('.Banner .owl-carousel');
        owl.owlCarousel({
            margin: 0,
            nav: false,
            loop: false,
            dots: false,
            rtl: $('body').hasClass('rtl'),
            responsive: {
                0: {
                    items: 1
                },
                600: {
                    items: 1
                },
                1000: {
                    items: 1
                }
            }
        })

        $('.owl-next').html('<i class="fa-solid fa-angle-right"></i>');
        $('.owl-prev').html('<i class="fa-solid fa-angle-left"></i>');
    }

    Ajax.GET("/api/Categories", {}, (data) => {
      //  let categories_filter = $('#CategoriesFilter').length > 0;

        $.each(data.data, function (index, row) {
            $('.NavBarCategories').append(TemplatesHTML.NavBarCategoriesHTML(row.categoryId, row.categoryName, row.imagePath));
            $('#footerCategories').append(TemplatesHTML.FooterCategoriesHTML(row.categoryId, row.categoryName));
            //if (categories_filter) {
            //    $('#CategoriesFilter').append(TemplatesHTML.CategoriesFilterHTML(row.categoryId, row.categoryName));
            //}
        })

        OnLoadCategories();
    }, () => { Alert.Error() });


    let isAuthenticated = $('#isAuthenticated').val() == 'True' ? true : false;
    let userId = $('#userId').val();

    if (isAuthenticated) {
        Ajax.GET("/api/Users/" + userId + "/Baskets/Count", {}, (e) => {
            $('#txtBasketCount').attr('data-count', e.data);
        }, () => { Alert.Error() });
    }


    //NavBar Fixed
    window.onscroll = function () {
        NavbarScroll();
    }

    NavbarScroll();

    function NavbarScroll() {
        if (window.scrollY > 300) {
            if (!$('#MainNav').hasClass('fixed'))
                $('#MainNav').addClass('fixed');

            $('BODY').css('padding-top', '114px');
        } else {
            $('#MainNav').removeClass('fixed');
            $('BODY').css('padding-top', '0px');
        }
    }
     
    //Taps
    $('.Taps div').click(function () {
        if (!$(this).hasClass('active')) {
            $(this).addClass('active');
            $('.Taps div').not(this).removeClass('active');

            let containtId = $(this).attr('data-for');
            $('.TapContaint div').removeClass('active');
            $('#' + containtId).addClass('active');
        }
    })


    //Input Type Password
    $('.button-password').click(function () {
        let target = $(this).attr('data-target');
        if ($(target).attr('type') == 'password') {
            $(target).attr('type', 'text');
            $(this).html('<i class="fas fa-eye-slash"></i>');
        } else {
            $(target).attr('type', 'password');
            $(this).html('<i class="fas fa-eye"></i>');
        }
    })


    $('.open-menu').click(function () {
        let btn = this;
        if ($('.BackdropCover').length == 0) {
            let cover = document.createElement('DIV');
            cover.className = 'BackdropCover';
            cover.onclick = function () {
                $(btn).click();
            };

            $('body').prepend(cover);
        }

        $($(btn).attr('data-target')).toggleClass('open');
        $('.BackdropCover').toggle();
    }) 
})
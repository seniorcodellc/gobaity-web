$(function () {

    Ajax.GET(`/api/Foods/` + $('#foodId').val(), {}, (data) => {

        if (data.state) {
            let images = data.data.images;
            let sizes = data.data.sizes;
            let reviews = data.data.reviews;
            let categories = data.data.categories;
            let otherByUser = data.data.otherByUser;
            let food = data.data.food;

            $.each(categories, function (index, row) {
                $('#tagsContainer').append('<span>' + row.categoryName + '</span>');
            });

            $.each(reviews, function (index, row) {
                $('#reviews').append(TemplatesHTML.ReviewHTML(row.userName, row.ratingDate, row.description, row.rating));
            });

            $.each(otherByUser, function (index, row) {
                $('#otherFoodsByUser').append(TemplatesHTML.FoodItemHTML(row.imagePath, row.foodId, row.foodName, row.userId, row.cookName, row.rate, row.preparationTime, row.price));
            });

            $.each(sizes, function (index, row) {
                $('#foodSizesContainer').append(TemplatesHTML.SizesHTML(row.foodsSizesId, row.sizeName, row.sizeDescription));
            });

            $.each(images, function (index, row) {
                if (index == 0) {
                    $('#FoodSliderSelectedImage').attr('src', row.imagePath);
                } else {
                    $('#ImgSilderContainer').append('<img class="img-responsive" src="' + row.imagePath + '" />');
                }
            });

            $('#txtFoodName').text(food.foodName);
            $('#txtStars').append((food.rate == null ? 0 : food.rate));
            $('#txtDelivery').append(food.preparationTime + ' ' + language("minute"));

            $('#txtDescription').text(food.description);
            $('#lnkProvider').text(food.cookName);
            $('#otherFoodTitle').append(' ' + food.cookName);

            $('#lnkProvider').attr('href', '/Foods/ProviterFoods/' + food.userId + '/' + food.cookName);

        
            CartQuantityEvent();
            FoodSliderEvent();
        } else {
            Alert.Error()
        }

    }, () => { Alert.Error() });

    $('#btnAddToCart').click(function () {

        let isAuthenticated = $('#isAuthenticated').val() == 'True';
        let userId = $('#userId').val();
        let foodId = $('#foodId').val();

        let BasketSizes = [];
        document.querySelectorAll('.SizeItem').forEach(item => {
            let qty = $(item).val();
            if (qty > 0) {
                let foodsSizesId = $(item).attr('data-foodssizesid');
                BasketSizes.push({ FoodsSizesId: foodsSizesId, Quantity: qty });
            }
        })

        let basket = {
            "FoodId": foodId,
            "BasketSizes": BasketSizes
        }

        if (!isAuthenticated) {
            Alert.Message({ state: false, message: language("pleaseLoginFirst") });
            return;
        }

        if (BasketSizes.length == 0) {
            Alert.Message({ state: false, message: language("pleaseSelectTheSize") });
            return;
        }

        Ajax.Post("/api/Users/" + userId + "/Baskets", basket, "POST", (e) => {
            if (e.state) {
                Alert.Message(e);
                $('#txtBasketCount').attr('data-count', e.data);
            } else {
                Alert.Error();
            }
        }, () => {
            Alert.Error();
        }, () => { });
    });
})
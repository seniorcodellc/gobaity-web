let userId = $('#userId').val();
let page = 0;
let length = 0;

$(function () {
    LoadTotal();
    LoadData();
})

function LoadTotal() {
    Ajax.GET(`/api/Users/${userId}/Baskets/Total`, {}, (data) => {
        if (data.state) {
            $('#txtTotal').text(data.data.total + ' ج.م');
            $('#txtDelivery').text(data.data.delivery + ' ج.م');
            $('#txtNet').text(data.data.net + ' ج.م');
        } else {
            Alert.Error();
        }
    }, () => { Alert.Error() });
}

function LoadData() {
    Ajax.GET(`/api/Users/${userId}/Baskets?page=${page}&size=30`, {}, (data) => {
        if (data.state) {
            $('#FoodsList').empty();
            $.each(data.data, function (index, row) {
                $('#FoodsList').append(TemplatesHTML.FoodCartHTML(row.imagePath, row.foodId, row.foodName, row.userId, row.cookName, row.rate, row.preparationTime, row.quantity, row.price, row.sizeName, row.foodsSizesId, row.basketId));
            })

            length = data.data.length;
            $('.txtPageNumber').text(language("page") + ' ' + (page + 1));
            CartEvent();
        } else {
            Alert.Error();
        }
    }, () => { Alert.Error() });
}

function CartEvent() {
    $('.Qty-container .max').click(function () {
        let txtQty = $(this).parents('.Qty-container').children('.num');
        BasketQuantityModify(txtQty, "Increase");
    })

    $('.Qty-container .min').click(function () {
        let txtQty = $(this).parents('.Qty-container').children('.num');
        BasketQuantityModify(txtQty, "Decrease");
    })

    $('.Cart-Remove').click(function () {
        let basket = {
            "FoodsSizesId": $(this).attr('data-foodsSizesId'),
            "BasketId": $(this).attr('data-basketId')
        }

        Ajax.Post("/api/Users/" + userId + "/Baskets", basket, "DELETE", (e) => {
            if (e.state) {
                $('#txtBasketCount').attr('data-count', e.data);
                page = 0;
                LoadData();
                LoadTotal();
            } else {
                Alert.Error();
            }
        }, () => {
            Alert.Error();
        }, () => { });
    })
}

function BasketQuantityModify(txtQty, action) {
    let basket = {
        "FoodsSizesId": txtQty.attr('data-foodsSizesId'),
        "BasketId": txtQty.attr('data-basketId')
    }

    Ajax.Post("/api/Users/" + userId + "/Baskets/" + action, basket, "PUT", (e) => {
        txtQty.val(e.data);
        LoadTotal();
    }, () => {
        Alert.Error();
    }, () => { });
}

function CompleatOrder() {
    if (length > 0) {
        location.href = '/Orders/Checkout';
    } else {
        Alert.Message({ state: false, message: language("addFoodsToCartFirst") });
    }
}

$('.PageNext').click(function () {
    if ($('#FoodsList .FoodsItem').length == size) {
        page = page + 1;
        LoadData();
    }
})

$('.PageBack').click(function () {
    if (page > 0) {
        page = page - 1;
        LoadData();
    }
})
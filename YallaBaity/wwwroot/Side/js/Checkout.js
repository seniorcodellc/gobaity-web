let userId = $('#userId').val();
let addressesLength = 0;

let simplepicker = new SimplePicker({
    zIndex: 10
});

$(function () {
    LoadAddreses();
    LoadTotal();
    LoadCart();
})

simplepicker.on('submit', (date, readableDate) => {
    if (date < new Date()) {
        Alert.Message({ state: false, message: language("msgYouCannotChooseADeliveryDateAndTimeLessThanTheCurrentDateAndTime") });
        simplepicker.open();
        return;
    }
   
    $('#txtOrderHandDate').val(date.toLocaleDateString() + ' ' + date.toLocaleTimeString());
});

simplepicker.on('close', (date) => {
    $('#now-span').click();
});


function DeliveryTimeNow() {
    $('#txtOrderHandDate').val("01/01/2000 12:00:00 PM");
}

function DeliveryTimeScheduleOrder() {
    simplepicker.open();
}

function LoadAddreses() {
    Ajax.GET(`/api/Users/${userId}/UsersAddreses`, {}, (data) => {
        if (data.state) {
            $('#UsersAddressList').empty();
            $.each(data.data, function (index, row) {
                $('#UsersAddressList').append(`<tr><td><div class="RadioButton"><span data-for="AddressesRadio_${row.usersAddressId}" data-name-for="AddressesRadio"></span><input type="radio" name="AddressesRadio" data-addresesid="${row.usersAddressId}" id="AddressesRadio_${row.usersAddressId}" hidden></div>  </td><th scope='row'>${(index + 1)}</th><td>${row.usersAddressName}</td><td>${row.apartmentNo}</td><td>${row.buildingNo}</td><td>${row.street}</td><td>${row.floor}</td><td>${row.address}</td></tr>`);
            })

            addressesLength = data.data.length;
            RadioButtonEvent();
        } else {
            Alert.Error();
        }
    }, () => { Alert.Error() });
}

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

function LoadCart() {
    Ajax.GET(`/api/Users/${userId}/Baskets?page=${0}&size=30`, {}, (data) => {
        if (data.state) {
            $('#CartList').empty();
            $.each(data.data, function (index, row) {
                $('#CartList').append(TemplatesHTML.FoodCartCheckOutHTML(row.imagePath, row.foodId, row.foodName, row.userId, row.cookName, row.rate, row.preparationTime, row.quantity, row.price, row.sizeName, row.foodsSizesId, row.basketId));
            })

            $('#cartCount').text('(' + data.data.length + ' ' + language("item") + ')');
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
                LoadCart();
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

function SaveOrder() {

    let addresses = $('.RadioButton [data-name-for="AddressesRadio"].active').attr('data-for');

    let order = {
        PaymentMethodsId: ($('#cash').prop('checked') ? 1 : 2),
        IsSchedule: $('#scheduleOrder').prop('checked'),
        HandDate: $('#txtOrderHandDate').val()
    };

    if (addressesLength == 0) {
        Alert.Message({ state: false, message: language("msgNoDeliveryAddressAddedPleaseAddAtLeastOneDeliveryAddress") });
        return;
    }

    if (addresses != undefined) {
        order.UsersAddressId = +$('#' + addresses).attr('data-addresesid');
    } else {
        Alert.Message({ state: false, message: language("msgPleaseSelectADeliveryAddress") });
        return;
    }

    Ajax.Post("/api/Users/" + userId + "/Orders", order, "POST", (e) => {
        Alert.Message(e);

        if (e.state) {
            $('#txtBasketCount').attr('data-count', 0);
            location.href = '/';
        }
    }, () => {
        Alert.Error();
    }, () => { });
} 
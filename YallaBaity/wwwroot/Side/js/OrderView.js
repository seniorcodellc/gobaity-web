let orderId = $('#orderId').val();
let userId = $('#userId').val();
 
$(function () { 
    LoadData();
})

function LoadData() {

    Ajax.GET(`/api/Users/${userId}/Orders/${orderId}`, {}, (data) => {
        if (data.state) {
            $('#OrderFoodsList').empty();
            $.each(data.data.orderDetails, function (index, row) {
                $('#OrderFoodsList').append(TemplatesHTML.OrderFoodItem(row.foodId, row.foodName, row.providerId, row.cookName, row.imagePath, row.sizeName, row.quantity, row.price));
            });
             
            $('#orderCode').val(data.data.order.orderCode);
            $('#orderState').val(data.data.order.orderStatusName);
            $('#orderDate').val(data.data.order.orderDate);
            $('#orderPayment').val(data.data.order.paymentMethodsName);

            if (data.data.order.handDate != '') {
                $('#orderHandDate').val(data.data.order.handDate);
                $('#orderHandDateContainer').show();
            } 

            $('#txtAddressName').text(data.data.order.usersAddressName);
            $('#txtBuildingNo').text(data.data.order.buildingNo);
            $('#txtApartmentNo').text(data.data.order.apartmentNo);
            $('#txtSteet').text(data.data.order.street);
            $('#txtFloor').text(data.data.order.floor);
            $('#txtAddress').text(data.data.order.address);
            $('#lat').val(data.data.order.latitude);
            $('#lng').val(data.data.order.longitude);
            initialize();
        } else {
            Alert.Error();
        }
    }, () => { Alert.Error() });
}
  
function initialize() { 
    let lat = +$('#lat').val();
    let lng = +$('#lng').val(); 

    var myLatlng = new google.maps.LatLng(lat, lng);
    var myOptions = {
        zoom: 15,
        center: myLatlng,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    map = new google.maps.Map(document.getElementById("map"), myOptions);
    PlaceMarker(lat, lng);
}
 
function addMarker(location) {
    marker = new google.maps.Marker({
        position: location,
        map: map
    });
}
 
function PlaceMarker(lat, lng) {
    CentralPark = new google.maps.LatLng(lat, lng);
    addMarker(CentralPark);
}  
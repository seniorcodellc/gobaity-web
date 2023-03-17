
var lng, lng, address,target;

function OpenModel() {
    $('.MapModel').show();
    $('.MapCover').show();
    lng = '';
    lat = '';
    address = '';
}

function CloseModel() {
    $('.MapModel').hide();
    $('.MapCover').hide();
    clear();
}
 
function GetAddress(lat, lng, onSuccess) {
    $.ajax({
        url: "https://api.geoapify.com/v1/geocode/reverse?lat=" + lat + "&lon=" + lng + "&apiKey=b3ff0cb3a61845c9972de3b3f4531f6f",
        data: {},
        method: 'GET',
        dataType: "json",
        success: onSuccess,
        error: function (e) {
            console.log(e);
        }
    });
}

let marker = [];
function clear() {
    for (let i = 0; i < marker.length; i++) {
        marker[i].setMap(null);
    }
}

function initMap() {

    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function (position) {
            var options = { zoom: 17, center: { lat: position.coords.latitude, lng: position.coords.longitude } }
            var map = new google.maps.Map(document.getElementById('map'), options);

            google.maps.event.addListener(map, 'click', function (event) {
                clear();
                addMarker({ coords: event.latLng });
                GetAddress(event.latLng.lat(), event.latLng.lng(), function (data) {
                    $('#MapAddress').text(data.features[0].properties.address_line1 + ' ' + data.features[0].properties.address_line2);
                    address = data.features[0].properties.address_line1 + ' ' + data.features[0].properties.address_line2;
                    lng = event.latLng.lng();
                    lat = event.latLng.lat();
                })
            });

            function addMarker(props) {
                marker.push(new google.maps.Marker({ position: props.coords, map: map, }));
                if (props.iconImage) { marker.setIcon(props.iconImage); }
                if (props.content) {
                    var infoWindow = new google.maps.InfoWindow({
                        content: props.content
                    });

                    marker.addListener('click', function () {
                        infoWindow.open(map, marker);
                    });
                }
            }
        }); 
    }
}
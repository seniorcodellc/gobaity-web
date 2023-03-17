
function StartOrdering() {
    if (localStorage.getItem('lat') != undefined && localStorage.getItem('lng') != undefined && localStorage.getItem('address') != undefined) {
        location.href = '/Foods';
    } else {
        OpenModel();
    }
}
 

function ConfirmLocation() {
    if (lng != '' && lat != '' && address != '') {
        localStorage.setItem("address", address);
        localStorage.setItem("lng", lng);
        localStorage.setItem("lat", lat);
        location.href = '/Foods';
    }
}

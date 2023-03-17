let userId = $('#userId').val();
let page_myFood = 0;
let size_myFood = 30;

let page_myOrder = 0;
let size_myOrder = 30;
$(function () {
    //Start Menu
    $('#ProfileMenu li').click(function () {
        let target = $(this).attr('data-target');
        $('.ProfileTaps > div').removeClass('active');
        $('#ProfileMenu li').removeClass('active');

        $(target).addClass('active');
        $(this).addClass('active');
    })
    //End Menu

    RadioButtonEvent();
    LoadAddreses();
    LoadUserProfile();
    LoadMyOrder(page_myOrder);

    if ($('#isProvider').val() == 'True') {
        LoadMyFood(page_myFood);
    }
})

//Start User Profile
function LoadUserProfile() {
    $('#ImageProfileImg').click(() => $('#ImageProfile').click());

    Ajax.GET(`/api/Governorates`, {}, (data) => {
        if (data.state) {
            $('#ddlUserProfileGovernorate').append('<option value="">-- ' + language('choose') + ' --</option>');
            $.each(data.data, function (index, item) {
                $('#ddlUserProfileGovernorate').append('<option value="' + item.governorateId + '">' + item.governorateName + '</option>');
            });
        } else {
            Alert.Error();
        }
    }, () => { Alert.Error() });

    Ajax.GET(`/api/Users/${userId}`, {}, (data) => {
        if (data.state) {
            if (data.data.gender) {
                $('[data-for="txtUserProfileGenderMale"]').click();
            } else {
                $('[data-for="txtUserProfileGenderFMale"]').click();
            }

            if (data.data.image != null) {
                $('#ImageProfileImg').attr('src', data.data.image);

                ImageProccess.toDataURL(data.data.image).then(dataUrl => {
                    var fileData = ImageProccess.dataURLtoFile(dataUrl, "imageName.jpg");
                    let dataTransfer = new DataTransfer();
                    dataTransfer.items.add(fileData);
                    $('#ImageProfile')[0].files = dataTransfer.files;
                })
            }

            $('#txtAccountUserName').val(data.data.userName);
            $('#txtAccountPhone').val(data.data.phone);

            if (data.data.isProvider) {
                $('.ProviderInputs').show();
                $('#ddlUserProfileGovernorate').val(data.data.governorateId);
                $('#txtUserProfileAddress').val(data.data.address);

                $('#UserProfileLocation').val(data.data.location);
                $('#UserProfileLatitude').val(data.data.latitude);
                $('#UserProfileLongitude').val(data.data.longitude);

                $('#UserProfileIsProvider').val('true');
            } else {
                $('#UserProfileIsProvider').val('false');
            }

        } else {
            Alert.Error();
        }
    }, () => { Alert.Error() });
}

$('#ImageProfile').change(function () {
    let input = this;

    if (input.files) {
        var reader = new FileReader();
        reader.onload = function (e) {
            $('#ImageProfileImg').attr('src', e.target.result);
        }

        reader.readAsDataURL(input.files[0]);
    }
});

function SaveUserProfile() {
    let isProvider = $('#UserProfileIsProvider').val();
    let latitude = $('#UserProfileLatitude').val();
    let longitude = $('#UserProfileLongitude').val();

    let UserInputs = Control.Validate('UserInputs');

    if (UserInputs == false)
        return;

    if (isProvider == 'true') {
        let ProviderInputs = Control.Validate('ProviderInputs');
        if (ProviderInputs == false)
            return;
    }

    if (latitude == '' || longitude == '') {
        Alert.Message({ state: false, message: language('pleaseAddTheLocaction') });
        return;
    }

    var formData = new FormData();

    if ($('#ImageProfile')[0].files.length > 0) {
        formData.append('Image', $('#ImageProfile')[0].files[0]);
    }

    //user
    formData.append('Gender', $('#txtUserProfileGenderMale').prop('checked'));
    formData.append('UserName', $('#txtAccountUserName').val());
    //provider
    formData.append('Latitude', latitude);
    formData.append('Longitude', longitude);
    formData.append('Location', $('#UserProfileLocation').val());
    formData.append('GovernorateId', $('#ddlUserProfileGovernorate').val());
    formData.append('Address', $('#txtUserProfileAddress').val());

    Ajax.PostForm(`/api/Users/${userId}`, formData, "PUT", (e) => {
        if (e.state) {
            Alert.Message(e);
        } else {
            Alert.Error();
        }
    }, () => {
        Alert.Error();
    }, () => { });



}

function ChangePassword() {
    let model = {
        OldPassword: $('#txtOldPassword').val(),
        NewPassword: $('#txtNewPassword').val()
    };

    if (Control.Validate('ChangePasswordForm')) {
        Ajax.Post(`/api/Users/ChangePassword/${userId}`, model, "PUT", (e) => {
            Alert.Message(e);
            if (e.state) {
                $('#ChangePasswordModal').modal('hide');

                $('#txtOldPassword').val('');
                $('#txtConfirmPassword').val('');
                $('#txtNewPassword').val('');
            }
        }, () => {
            Alert.Error();
        }, () => { });
    }
}
//End User Profile
//Start UsersAddreses 
$('#UserAddressModal').on('hidden.bs.modal', function (e) {
    $('#hdUsersAddressId').val(0);
    $('#txtAddressName').val('');
    $('#txtStreet').val('');
    $('#txtBuildingNo').val('');
    $('#txtApartmentNo').val('');
    $('#txtFloorNo').val('');
    $('#txtAddress').val('');
    $('#hdLng').val('');
    $('#hdLat').val('');

    $('#AddLocationMsg').attr('hidden', 'hidden');
    Control.ClearValidation('UserAddressesForm');

    LoadAddreses();
})

$('#UserAddressesForm input,#UserAddressesForm textarea,#UserAddressesForm select,#UserAddressesForm input[type = checkbox]').on('blur', function (e) {
    Control.Validate('UserAddressesForm', (e.target.id));
});

function LoadAddreses() {
    Ajax.GET(`/api/Users/${userId}/UsersAddreses`, {}, (data) => {
        if (data.state) {
            $('#UsersAddressList').empty();
            $.each(data.data, function (index, row) {
                $('#UsersAddressList').append(`<tr><td><a href="javascript:void(0);" onclick='DeleteAddreses(${row.usersAddressId})'>${language('delete')}</a>&nbsp;|&nbsp;<a href="javascript:void(0);" onclick='EditAddreses(${row.usersAddressId})'>${language('edit')}</a></td><th scope='row'>${(index + 1)}</th><td>${row.usersAddressName}</td><td>${row.apartmentNo}</td><td>${row.buildingNo}</td><td>${row.street}</td><td>${row.floor}</td><td>${row.address}</td></tr>`);
            })
        } else {
            Alert.Error();
        }
    }, () => { Alert.Error() });
}

function AddAddreses() {
    $('#UserAddressModalTitle').text(language('addAddress'));
    $('#UserAddressModal').modal('show');
}

function EditAddreses(userAddressId) {
    $('#UserAddressModalTitle').text(language('editAddress'));
    $('#UserAddressModal').modal('show');

    Ajax.GET(`/api/Users/${userId}/UsersAddreses/${userAddressId}`, {}, (response) => {
        if (response.state) {
            $('#hdUsersAddressId').val(response.data.usersAddressId);
            $('#txtAddressName').val(response.data.usersAddressName);
            $('#txtStreet').val(response.data.street);
            $('#txtBuildingNo').val(response.data.buildingNo);
            $('#txtApartmentNo').val(response.data.apartmentNo);
            $('#txtFloorNo').val(response.data.floor);
            $('#txtAddress').val(response.data.address);
            $('#hdLng').val(response.data.longitude);
            $('#hdLat').val(response.data.latitude);
        } else {
            Alert.Error();
        }
    }, () => { Alert.Error() });
}

function SaveAddreses() {
    if (Control.Validate('UserAddressesForm')) {

        let usersAddressId = $('#hdUsersAddressId').val();
        let userAddress = {
            "usersAddressName": $('#txtAddressName').val(),
            "address": $('#txtAddress').val(),
            "apartmentNo": $('#txtApartmentNo').val(),
            "buildingNo": $('#txtBuildingNo').val(),
            "street": $('#txtStreet').val(),
            "floor": $('#txtFloorNo').val(),
            "latitude": $('#hdLat').val(),
            "longitude": $('#hdLng').val()
        }

        if (userAddress.latitude == "" || userAddress.longitude == "") {
            Alert.Message({ state: false, message: language('pleaseAddTheLocaction') });
            return;
        }

        Ajax.Post(`/api/Users/${userId}/UsersAddreses` + (usersAddressId == "0" ? "" : ("/" + usersAddressId)), userAddress, (usersAddressId == "0" ? "POST" : "PUT"), (e) => {
            if (e.state) {
                Alert.Message(e);
                $('#UserAddressModal').modal('hide');
            } else {
                Alert.Error();
            }
        }, () => {
            Alert.Error();
        }, () => { });
    }
}

function DeleteAddreses(userAddressId) {
    Alert.Confirm(() => {
        Ajax.Post(`/api/Users/${userId}/UsersAddreses/${userAddressId}`, {}, "DELETE", (e) => {
            if (e.state) {
                Alert.Message(e);
                LoadAddreses();
            } else {
                Alert.Error();
            }
        }, () => {
            Alert.Error();
        }, () => { });
    })
}

function ConfirmLocation() {
    if (lng != '' && lat != '' && address != '') {

        console.log(target);

        if (target == 'address') {
            $('#hdLng').val(lng);
            $('#hdLat').val(lat);

            $('#AddLocationMsg').removeAttr('hidden');
        } else if (target == 'userProfile') {
            $('#UserProfileLocation').val(address);
            $('#UserProfileLongitude').val(lng);
            $('#UserProfileLatitude').val(lat);
        }

        CloseModel();
    }
}
//End UsersAddreses
//Start MyOrder
function LoadMyOrder(page) {
    Ajax.GET(`/api/Users/${userId}/Orders`, {}, (data) => {
        if (data.state) {
            $('#MyOrdersList').empty();

            let previousOrderId=0;
            $.each(data.data, function (index, row) {

                if (row.orderId != previousOrderId) {
                    $('#MyOrdersList').append(TemplatesHTML.OrderHead(row.orderId, row.orderCode, row.shortDate, row.deliveryCost, row.total, row.netTotal, row.orderStatusName));
                }

                $('#MyOrdersList').append(TemplatesHTML.OrderFoodItem(row.foodId, row.foodName, row.providerId, row.cookName, row.imagePath, row.sizeName, row.quantity, row.price));

                previousOrderId = row.orderId;
            });

            $('#Orders .txtPageNumber').text(language('page') + ' ' + (page + 1));
        } else {
            Alert.Error();
        }
    }, () => { Alert.Error() }); 
}

$('#Orders .PageNext').click(function () {
    if ($('#MyOrdersList .FoodsItem').length == size_myOrder) {
        page_myOrder = page_myOrder + 1;
        LoadMyOrder(page_myOrder);
    }
})

$('#Orders .PageBack').click(function () {
    if (page_myOrder > 0) {
        page_myOrder = page_myOrder - 1;
        LoadMyOrder(page_myOrder);
    }
})
//End MyOrder
//Start MyFood
function LoadMyFood(page) {
    Ajax.GET(`/api/Foods/Provider?providerId=${userId}&page=${page}&size=${size_myFood}&userId=-1&priceFrom=-1&priceTo=-1&foodName=&order=&latitude=&longitude=`, {}, (data) => {
        if (data.state) {
            $('#MyFoodsList').empty();
            $.each(data.data, function (index, row) {
                $('#MyFoodsList').append(TemplatesHTML.FoodItemHTML(row.imagePath, row.foodId, row.foodName, row.userId, row.cookName, row.rate, row.preparationTime, row.price, '<button title="Delete" class="controls" onclick="RemoveFood(' + row.foodId + ')"><i class="fas fa-trash-alt"></i></button> <a href="/Foods/Edit/' + row.foodId + '" title="Edit" class="controls"><i class="far fa-edit"></i></a>'));
            });

            $('#MyFoods .txtPageNumber').text(language('page') +' ' + (page + 1));
        } else {
            Alert.Error();
        }
    }, () => { Alert.Error() });
}

function RemoveFood(foodId) {
    Ajax.Post(`/api/Foods/${foodId}`, {}, "DELETE", (e) => {
        if (e.state) {
            Alert.Message(e);
            page_myFood = 0;
            LoadMyFood(page_myFood);
        } else {
            Alert.Error();
        }
    }, () => {
        Alert.Error();
    }, () => { });
}

$('#MyFoods .PageNext').click(function () {
    if ($('#MyFoodsList .FoodsItem').length == size_myFood) {
        page_myFood = page_myFood + 1; 
        LoadMyFood(page_myFood);
    }
})

$('#MyFoods .PageBack').click(function () {
    if (page_myFood > 0) {
        page_myFood = page_myFood - 1; 
        LoadMyFood(page_myFood);
    }
})
//End  MyFood

$(function () {
    Ajax.GET(`/api/Governorates`, {}, (data) => {
        if (data.state) {
            $('#ddlGovernorate').append('<option value="">-- ' + language("choose") + ' --</option>');
            $.each(data.data, function (index, item) {
                $('#ddlGovernorate').append('<option value="' + item.governorateId + '">' + item.governorateName + '</option>');
            });
        } else {
            Alert.Error();
        }
    }, () => { Alert.Error() });


    $('.UploadNationalIdCard').click(function () {
        let target = $(this).attr('data-target');
        $(target).click();
    })

    $('.SignInForm input[type=file]').change(function () {
        let input = this;
        $(input).parent('.form-group').children('IMG').remove();

        let img = document.createElement('IMG');
        img.style.maxWidth = "200px";
        if (input.files) {
            var reader = new FileReader();
            reader.onload = function (e) {
                img.setAttribute('src', e.target.result);
            }

            reader.readAsDataURL(input.files[0]);
        }

        $(input).parent('.form-group').append(img)
    });

    $('#JoinAsProvider input,#JoinAsProvider textarea,#JoinAsProvider select,#JoinAsProvider input[type = checkbox]').on('blur', function (e) {
        Control.Validate('JoinAsProvider', (e.target.id));
    });

    $('#btnSave').click(function () {
        let userId = $('#userId').val();
        let NationalIdCardFace = $('#NationalIdCardFace')[0].files;
        let NationalIdcardBack = $('#NationalIdcardBack')[0].files;
        let Location = $('#hdLocation').val();
        let Latitude = $('#hdLat').val();
        let Longitude = $('#hdLng').val();
        let Address = $('#txtAddress').val();
        let Governorate = $('#ddlGovernorate').val();


        var form = new FormData();
        form.append("NationalIdcardFace", NationalIdCardFace[0]);
        form.append("NationalIdcardBack", NationalIdcardBack[0]);
        form.append("Location", Location);
        form.append("Latitude", Latitude);
        form.append("Longitude", Longitude);
        form.append("Address", Address);
        form.append("GovernorateId", Governorate);

      
        
        let state = Control.Validate('JoinAsProvider');  

        if (state) {

            if (Latitude == '' || Longitude == '') {
                Alert.Message({ state: false, message: language('pleaseAddTheLocaction') });
                return;
            }

            if (NationalIdCardFace.length == 0) {
                Alert.Message({ state: false, message: language('pleaseAddTheFrontOfTheCard') });
                return;
            }

            if (NationalIdcardBack.length == 0) {
                Alert.Message({ state: false, message: language('pleaseAddTheBackOfTheCard') });
                return;
            }

            $('#btnSave').attr('disabled', 'disabled');

            Ajax.PostForm(("/api/Users/SetUserToProvider/" + userId), form, "PUT", (e) => {
                if (e.state) {
                    Alert.Message(e);

                    setTimeout(() => {
                        location.href = '/Account/Profile';
                    }, 2000);
                } else {
                    Alert.Error();
                }
            }, () => {
                Alert.Error();
            }, () => {
                $('#btnSave').removeAttr('disabled');
            });
        }
    })

})

function ConfirmLocation() {
    if (lng != '' && lat != '' && address != '') {
        $('#hdLocation').val(address);
        $('#hdLng').val(lng);
        $('#hdLat').val(lat);

        CloseModel();
    }
}
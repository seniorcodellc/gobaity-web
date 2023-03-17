$(function () {  
    let foodId = $('#foodId').val();
    if (foodId > 0) {
        Ajax.GET(`/api/Foods/${foodId}`, {}, (data) => {
            if (data.state) {
                let dataTransfer = new DataTransfer();
                $.each(data.data.images, function (index, item) {
                    ImageProccess.toDataURL(item.imagePath).then(dataUrl => {
                        var fileData = ImageProccess.dataURLtoFile(dataUrl, "imageName.jpg");
                        dataTransfer.items.add(fileData);
                        $('#Images')[0].files = dataTransfer.files;
                    })

                    $('#ImagesContainer').append('<img src="' + item.imagePath + '" />');
                });

                let sizeItem = $('.SizeItem').remove();
                $.each(data.data.sizes, function (index, item) {
                    let _sizeItem = sizeItem.clone();
                    $(_sizeItem).children('.SizesDescription').val(item.sizeDescription);
                    $(_sizeItem).children('DIV').children('.SizesPrices').val(item.price)
                    $(_sizeItem).children('.SizesId').val(item.sizeId); 

                    $('#SizesContainer').append(_sizeItem);
                });

                let categories = [];
                $.each(data.data.categories, function (index, item) {
                    categories.push(item.categoryId);
                });

                $('#ddlCategories').val(categories).trigger('change');

                $('#txtDescription').val(data.data.food.description);
                $('#txtPreparationTime').val(data.data.food.preparationTime);
                $('#txtPrice').val(data.data.food.price);
                $('#txtTitle').val(data.data.food.foodName);

            } else {
                Alert.Error();
            }
        }, () => { Alert.Error() });
    }


    Ajax.GET(`/api/Categories`, {}, (data) => {
        if (data.state) {
            $.each(data.data, function (index, item) {
                $('#ddlCategories').append('<option value="' + item.categoryId + '">' + item.categoryName + '</option>');
            });

            $('#ddlCategories').select2({
                placeholder: language("chooseCategories"),
                allowClear: true,
                dir: "rtl",
            });
        } else {
            Alert.Error();
        }
    }, () => { Alert.Error() });

    Ajax.GET(`/api/Sizes`, {}, (data) => {
        if (data.state) {
            $('.SizesId').append('<option value="">-- ' + language("choose") + ' --</option>');
            $.each(data.data, function (index, item) {
                $('.SizesId').append('<option value="' + item.sizeId + '">' + item.sizeName + '</option>');
            });
        } else {
            Alert.Error();
        }
    }, () => { Alert.Error() });

    $('#btnAddImages').click(function () {
        $('#Images').click();
    })

    $('#Images[type=file]').change(function () {
        $('#ImagesContainer').empty();

        let images = $(this)[0].files;

        if (images.length > 5) {
            Alert.Message({ state: false, message: language("youAreAllowedToChooseUpToFivePhotos") })
            Control.FileReset("Images");
            return;
        }

        let readers = [];
        for (var i = 0; i < images.length; i++) {
            readers.push(new FileReader());
            readers[i].onload = function (e) {
                let img = document.createElement('IMG');
                img.setAttribute('src', e.target.result);
                $('#ImagesContainer').append(img);
            }
            readers[i].readAsDataURL(images[i]);
        }
    });

    $('#btnAddSize').click(function () {
        $('#SizesContainer').append($('.SizeItem').prop('outerHTML'));
    })

    $('#FoodsAction input,#FoodsAction textarea,#FoodsAction select,#FoodsAction input[type = checkbox]').on('blur', function (e) {
        Control.Validate('FoodsAction', (e.target.id));
    });

    $('#btnSave').click(function () {

        let userId = $('#userId').val();

        let title = $('#txtTitle').val();
        let Price = $('#txtPrice').val();
        let PreparationTime = $('#txtPreparationTime').val();
        let Description = $('#txtDescription').val();
        let Sizes = LoadSizes();
        let Categories = $('#ddlCategories').val();
        let images = $('#Images')[0].files;

     //  let state = (Control.Validate('', 'txtTitle') && Control.Validate('', 'txtPrice') && Control.Validate('', 'txtPreparationTime') && Control.Validate('', 'txtDescription')) && Control.Validate('', 'Images');
         let state = (Control.Validate('FoodsAction') );

        if (Categories.length == 0) {
            state = false;
            $('.select2-selection').css('border', '1px solid #ff0000');
            $('.select2-selection').after('<span data-for="categories" class="text-invalid">' + language("thisFieldIsRequired") + '</span>')
        } else {
            $('[data-for="categories"]').remove();
            $('.select2-selection').css('border', '1px solid #F6F6F6');
        }

        if (state) {
           

            if (Sizes.length == 0) {
                Alert.Message({ state: false, message: language("pleaseAddSize") });
                return;
            }


            var form = new FormData();
            form.append("FoodName", title);
            form.append("Price", Price);
            form.append("Description", Description);
            form.append("PreparationTime", PreparationTime);
            form.append("UserId", userId);
            form.append("Sizes", JSON.stringify(Sizes));
            form.append("Categories", JSON.stringify(Categories));

            for (var i = 0; i < images.length; i++) {
                form.append("images", images[i]);
            }

            $('#btnSave').attr('disabled','disabled');

            Ajax.PostForm("/api/Foods" + (foodId == 0 ? "" : ("/" + foodId)), form, (foodId == 0 ? "POST" : "PUT"), (e) => {
                if (e.state) {
                    Alert.Message(e);
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

function LoadSizes() {
    let sizes = [];
    document.querySelectorAll('.SizesId').forEach((item, index) => {
        let val = $(item).val();
        if (val != '' && val != null) {
            let price = $('.SizesPrices:nth(' + index + ')').val();

            sizes.push({
                SizeId: +val,
                Price: ((isNaN(price) || price == '') ? 0 : +price),
                SizeDescription: $('.SizesDescription:nth(' + index + ')').val()
            });
        }
    });

    return sizes;
}

function SizeChange(even) {
    let size = $(even).val();
    $.each($('.SizesId').not(even), function (index, row) {
        if ($(row).val() == size) {
            $(even).val('');
            Alert.Message({ state: false, message: language("sizeCannotBeDuplicated") });
        }
    });
}
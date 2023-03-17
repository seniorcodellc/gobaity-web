var modelId = 0;
$(function () {
    $('#FormModel').on('hidden.bs.modal', function (e) {
        Control.ClearData('FormModel');
        Control.ClearValidation('FormModel');
    })

    $('#FormModel input,#FormModel select,#FormModel input[type = checkbox]').on('blur', function (e) {
        Control.Validate('FormModel', (e.target.id));
    });
})

function OpenModel(id = '0') {
    if (id != '0') {
        Ajax.GET(baseUrl + "/" + id, {}, (result) => {
            let props = Object.getOwnPropertyNames(result.data);
            let dataTransfer = new DataTransfer();

            props.forEach(item => {
                if ($('#' + item).attr('type') == 'checkbox') {
                    $('#' + item).prop('checked', result.data[item]);
                } else if ($('#' + item).attr('type') == 'file') {
                    let path = result.data[item]; 
                    let fileName = path.substring(path.lastIndexOf('/') + 1, path.length);

                    $('#imagePathInput').val(fileName);
                    
                    ImageProccess.toDataURL(path).then(dataUrl => {
                        var fileData = ImageProccess.dataURLtoFile(dataUrl, fileName);
                        dataTransfer.items.add(fileData);
                        $('#' + item)[0].files = dataTransfer.files;
                    }) 
                } else {
                    $('#' + item).val(result.data[item]);
                }
            });
        }, () => { Alert.Error() });

        $('#FormModel .modal-title').text(language("update"));
    } else {
        $('#FormModel .modal-title').text(language("add"));
    }

    modelId = id;
    $('#FormModel').modal('show');
}

function Save() {
    if (Control.Validate('FormModel')) {

        let form = Control.GetElemntAsForm('FormModel');
        form["backgroundColor"] = parseInt(form["backgroundColor"], 16);
      
        Ajax.PostForm(baseUrl + (modelId == "0" ? "" : ("/" + modelId)), form, (modelId == "0" ? "POST" : "PUT"), (e) => {
            Alert.Message(e);
            Ajax.RefrishDataTable();
        }, () => {
            Alert.Error();
        }, () => {
            $('#FormModel').modal('hide');
        });
    }
}
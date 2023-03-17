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
            props.forEach(item => {
                if ($('#' + item).attr('type') == 'checkbox') {
                    $('#' + item).prop('checked', result.data[item])
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
        Ajax.Post(baseUrl + (modelId == "0" ? "" : ("/" + modelId)), Control.GetElemntAsObject('FormModel'), (modelId == "0" ? "POST" : "PUT"), (e) => {
            Alert.Message(e);
            Ajax.RefrishDataTable();
        }, () => {
            Alert.Error();
        }, () => {
            $('#FormModel').modal('hide');
        }); 
    }
}
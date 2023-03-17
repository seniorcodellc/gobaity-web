
function OpenModel(id) {

    Ajax.GET(baseUrl + '/'+id, {  }, (data) => {
        let props = Object.getOwnPropertyNames(data.data);
        props.forEach(item => {
            if ($('#' + item).attr('type') == 'checkbox') {
                $('#' + item).prop('checked', data.data[item])
            } else if ($('#' + item).prop('tagName') == 'IMG') {
                $('#' + item).attr('src', data.data[item]);
            } else {
                $('#' + item).val(data.data[item]);
            }
        });

        if (data.data.isProvider == true) {
            $('#governorate').val(CurrentLang == 'A' ? data.data.governorateAname : data.data.governorateEname);
            $('#location').attr('src', "https://www.google.com/maps/embed?pb=!1m14!1m12!1m3!1d27160.536091021044!2d" + data.data.longitude + "!3d" + data.data.latitude + "!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!5e1!3m2!1sen!2seg!4v1662307675346!5m2!1sen!2seg");
        } else {
            $('.providerField').remove();
        }
    }, () => { Alert.Error() });

    $('#FormModel').modal('show');
}
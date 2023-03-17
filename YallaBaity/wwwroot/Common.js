$(function () {

    $('.integer').keypress(function (e) {
        $(this).val('');
        if ((event.which < 48 || event.which > 57)) {
            event.preventDefault();
        }
    })

    if ($.fn.datepicker != undefined) {
        $('.datepicker').datepicker({
            dateFormat: "yy-mm-dd",
            showAnim: "slideDown",
            showButtonPanel: true,
            showOtherMonths: true,
            selectOtherMonths: true
        });
    }

    CurrentLang = $('body').hasClass('rtl') ? "A" : "E";
})

var CurrentLang;

var Ajax = {
    LoadDataTable: function (element, url, columns) {
        $(element).DataTable({
            "ajax": {
                "url": url,
                "type": 'POST',
                'datatype': 'json'
            },
            "columns": columns,
            'serverSide': 'true',
            'order': [0, 'asc'],
            'processing': 'true',
            "language": {
                "decimal": "",
                "emptyTable": language("noDataAvailableInTable"),
                "info": language("showing") + " _START_ " + language("to") + " _END_ " + language("of") +" _TOTAL_ " + language("entries"),
                "infoEmpty": language("showing") +" 0 " + language("to") +" 0 " + language("of") +" 0 " + language("entries"),
                "infoFiltered": "(" + language("filtered") + " " + language("from") + " _MAX_ " + language("total") + " " + language("entries") + ")",
                "infoPostFix": "",
                "thousands": ",",
                "lengthMenu": language("show") + " _MENU_ " + language("entries"),
                "loadingRecords": language("loading"),
                "processing": "",
                "search": language("search"),
                "zeroRecords": language("noMatchingRecordsFound"),
                "paginate": {
                    "first": language("first"),
                    "last": language("last"),
                    "next": language("next"),
                    "previous": language("previous")
                },
                "aria": {
                    "sortAscending": ": activate to sort column ascending",
                    "sortDescending": ": activate to sort column descending"
                }
            }
        });
    },
    RefrishDataTable: function (table = 'tblData') {
        $('#' + table).DataTable().ajax.reload();
    },
    GET: function (url, body, onSuccess, onError) {
        $.ajax({
            url: url,
            data: body,
            method: 'GET',
            dataType: "json",
            //headers: {
            //    "Accept-Language": (CurrentLang == 'A' ? 'ar' : 'en')
            //},
            success: onSuccess,
            error: onError
        });
    },
    Post: function (url, body, method, onSuccess, onError, onComplete = () => { }) {
        $.ajax({
            url: url,
            type: method,
            contentType: "application/json;charset=utf-8",
            dataType: 'json',
            data: JSON.stringify(body),
            success: onSuccess,
            error: onError,
            complete: onComplete
        });
    },
    PostForm: function (url, form, method, onSuccess, onError, onComplete = () => { }) {
        $.ajax({
            url: url,
            method: method,
            contentType: false,
            processData: false,
            data: form,
            success: onSuccess,
            error: onError,
            complete: onComplete
        });
    },
    LoadDropDown: function (element, url, valueMember, displayMemberAr, displayMemberEn, onLoad = () => { }) {
        Ajax.GET(url, {}, (data) => {
            if (data.state) {
                $('#' + element).append('<option value="">--' + language("choose") + '--</option>');

                $.each(data.data, function (index, item) {
                    $('#' + element).append('<option value="' + item[valueMember] + '">' + item[(CurrentLang == 'A' ? displayMemberAr : displayMemberEn)] + '</option>');
                });
                onLoad();
            } else {
                Alert.Error();
            }
        }, () => { Alert.Error(); })
    },
    ActiveToggle: function (url, button) {
        Ajax.Post(url, {}, 'PUT', (e) => {
            Alert.Message(e);
            $(button).html('<i class="mdi mdi-eye' + (e.data == true ? '' : '-off') + '"></i>');

            if (e.data == true) {
                $(button).addClass('btn-success');
                $(button).removeClass('btn-danger');
            } else {
                $(button).removeClass('btn-success');
                $(button).addClass('btn-danger');
            }
        }, () => { Alert.Error(); })
    },
    Delete: function (url) {
        Alert.Confirm(() => {
            Ajax.Post(url, {}, 'DELETE', (e) => { Alert.Message(e); }, () => { Alert.Error() }, () => { Ajax.RefrishDataTable(); });
        })
    }
}

var Alert = {
    Error: function () {
        Swal.fire({
            position: 'top-center',
            icon: 'error',
            title: language("anErrorHasOccurred"),
            showConfirmButton: false,
            timer: 1500
        });
    },
    Message: function (e) {
        Swal.fire({
            position: 'top-center',
            icon: (e.state ? 'success' : 'error'),
            title: e.message,
            showConfirmButton: false,
            timer: 1500
        });
    },
    Confirm: function (action) {
        Swal.fire({
            title: language("areYouSure"),
            text: language("youWontBeAbleToRevertThis"),
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: language("yesDeleteIt"),
            cancelButtonText: language("noCancel")
        }).then((result) => {
            if (result.value) {
                action();
            }
        })
    }
}

var Control = {
    GetElemntAsForm: function (parent) {
        let form = new FormData();
        document.querySelectorAll('#' + parent + ' input,#' + parent + ' select').forEach(item => {
            if ($('#' + item.id).attr('type') == 'checkbox') {
                form.append(item.id, $('#' + item.id).prop('checked'));
            } else if ($('#' + item.id).attr('type') == 'file') {
                form.append(item.id, $('#' + item.id)[0].files[0]);
            } else if (document.getElementById(item.id).tagName == 'SELECT') {
                form.append(item.id, (item.value == '' ? null : item.value));
            } else {
                form.append(item.id, item.value);
            }
        });

        return form;
    },
    GetElemntAsObject: function (parent) {
        let fields = {};
        document.querySelectorAll('#' + parent + ' input,#' + parent + ' select').forEach(item => {
            if (document.getElementById(item.id).type == 'checkbox') {
                fields[item.id] = $('#' + item.id).prop('checked');
            } else if (document.getElementById(item.id).tagName == 'SELECT') {
                fields[item.id] = (item.value == '' ? null : item.value);
            } else {
                fields[item.id] = item.value;
            }
        });

        return fields;
    },
    ClearValidation: function (parent) {
        $('#' + parent + ' .text-invalid').remove();
        $('#' + parent + ' .is-invalid').removeClass('is-invalid');
    },
    Validate: function (parent, element = '') {
        if (element == '') {
            Control.ClearValidation(parent);
        } else {
            $('#' + element).removeClass('is-invalid');
            $('[data-field=' + element + ']').remove();
        }

        let valid = true;

        for (let item of document.querySelectorAll((element == '' ? ('#' + parent + ' textarea,#' + parent + ' input,#' + parent + ' select,#' + parent + ' table') : ('#' + element)))) {
            let value = item.value;

            if (item.hasAttribute('data-requird')) {
                if (value.trim() == '') {
                    $(item).addClass('is-invalid');
                    $(item).after('<span class="text-invalid" data-field="' + item.id + '">' + Strings.GetDefaultIfNullOrUndefinedOrEmpty(item.getAttribute('data-requird-message'), 'This Field Is Requird') + '</span>');
                    $(item).focus();
                    valid = false;
                    continue;
                }
            }

            if (item.hasAttribute('data-numberonly')) {
                if (isNaN(value)) {
                    $(item).addClass('is-invalid');
                    $(item).after('<span class="text-invalid" data-field="' + item.id + '">' + Strings.GetDefaultIfNullOrUndefinedOrEmpty(item.getAttribute('data-numberonly-message'), 'Only numbers must be entered') + '</span>');
                    $(item).focus();
                    valid = false;
                    continue;
                }
            }

            if (item.hasAttribute('data-minlength')) {
                let minlength = +item.getAttribute('data-minlength');
                if (value.length < minlength) {
                    $(item).addClass('is-invalid');
                    $(item).after('<span class="text-invalid" data-field="' + item.id + '">' + Strings.GetDefaultIfNullOrUndefinedOrEmpty(item.getAttribute('data-minlength-message'), 'The field must not be less than ' + minlength + ' characters') + '</span>');
                    $(item).focus();
                    valid = false;
                    continue;
                }
            }

            if (item.hasAttribute('data-maxlength')) {
                let maxlength = +item.getAttribute('data-maxlength');
                if (value.length > maxlength) {
                    $(item).addClass('is-invalid');
                    $(item).after('<span class="text-invalid" data-field="' + item.id + '">' + Strings.GetDefaultIfNullOrUndefinedOrEmpty(item.getAttribute('data-maxlength-message'), 'The field must not exceed ' + maxlength + ' characters') + '</span>');
                    $(item).focus();
                    valid = false;
                    continue;
                }
            }

            if (item.hasAttribute('data-regex')) {
                let dataregex = item.getAttribute('data-regex');
                var regexp = new RegExp(dataregex);
                if (value.search(regexp) == -1) {
                    $(item).addClass('is-invalid');
                    $(item).after('<span class="text-invalid" data-field="' + item.id + '">' + Strings.GetDefaultIfNullOrUndefinedOrEmpty(item.getAttribute('data-regex-message'), 'Text does not match the format') + '</span>');
                    $(item).focus();
                    valid = false;
                    continue;
                }
            }

            if (item.hasAttribute('data-table-minrows')) {
                let tablerows = +item.getAttribute('data-table-minrows');

                if ($('#' + item.id + ' tbody tr').length < tablerows) {
                    $(item).addClass('is-invalid');
                    $(item).after('<span class="text-invalid" data-field="' + item.id + '">' + Strings.GetDefaultIfNullOrUndefinedOrEmpty(item.getAttribute('data-table-minrows-message'), 'Please Fill The Table') + '</span>');
                    $(item).focus();
                    valid = false;
                    continue;
                }
            }

            if (item.hasAttribute('data-valueby')) {
                let valueby = +$('#' + item.getAttribute('data-valueby')).val();
                let operator = item.getAttribute('data-valueby-operator');
                let result;
                switch (operator) {
                    case '=':
                        result = (valueby == +value);
                        break;
                    case '>':
                        result = (valueby > +value);
                        break;
                    case '<':
                        result = (valueby < +value);
                        break;
                    case '>=':
                        result = (valueby >= +value);
                        break;
                    case '<=':
                        result = (valueby <= +value);
                        break;
                    case '!=':
                        result = (valueby != +value);
                        break;
                    default:
                        result = true;
                }

                if (!result) {
                    $(item).addClass('is-invalid');
                    $(item).after('<span class="text-invalid" data-field="' + item.id + '">' + Strings.GetDefaultIfNullOrUndefinedOrEmpty(item.getAttribute('data-valueby-message'), (item.id + 'must to be ' + operator + ' for ' + item.getAttribute('data-valueby'))) + '</span>');
                    $(item).focus();
                    valid = false;
                    continue;
                }
            }

            if (item.hasAttribute('data-remote')) {
                let remote = item.getAttribute('data-remote') + "?" + item.id + "=" + value;
                Ajax.GET(remote, {}, (body) => {
                    if (JSON.parse(body)) {
                        $(item).addClass('is-invalid');
                        $(item).after('<span class="text-invalid" data-field="' + item.id + '">' + Strings.GetDefaultIfNullOrUndefinedOrEmpty(item.getAttribute('data-remote-message'), 'This text is already registered') + '</span>');
                        $(item).focus();
                        valid = false;
                    }
                }, () => {
                    Alert.Error();
                })
            }
        }

        return valid;
    },
    ClearData: function (parent) {
        $('#' + parent + ' input,#' + parent + ' select').val('');
        $('#' + parent + ' input[type=checkbox]').prop('checked', false);
        $('#' + parent + ' input[type=hidden]').val('0');
    },
    FetchDropDown: function (element, data, valueMember, displayMemberAr, displayMemberEn) {
        $('#' + element).append('<option value="">' + language('choose') + '</option>');
        $.each(data, function (index, item) {
            $('#' + element).append('<option value="' + item[valueMember] + '">' + item[(CurrentLang == 'ar' ? displayMemberAr : displayMemberEn)] + '</option>');
        });
    },
    FileReset: function (element) {
        $('#' + element).attr('type', 'text')
        $('#' + element).attr('type', 'file')
    }
}

var Buttons = {
    Delete: function (url) {
        return '<button class="btn btn-danger" onclick="Ajax.Delete(`' + url + '`)"><i class="mdi mdi-delete-forever"></i></button>';
    },
    Update: function (id) {
        return '<button class="btn btn-primary" onclick="OpenModel(`' + id + '`)"><i class="mdi mdi-table-edit"></i></button>';
    },
    Active: function (url, state) {
        return '<button class="btn btn-' + (state == true ? 'success' : 'danger') + '" onclick="Ajax.ActiveToggle(`' + url + '`,this)"><i class="mdi mdi-eye' + (state == true ? '' : '-off') + '"></i></button>';
    },
    Approval: function (id) {
        return '<button class="btn btn-success" onclick="Approval(`' + id + '`)"><i class="mdi mdi-check-circle-outline"></i></button>';
    },
    View: function (id) {
        return '<button class="btn btn-primary" onclick="OpenModel(`' + id + '`)"><i class="mdi mdi-file-find"></i></button>';
    },
    Group: function (buttons) {
        return '<div class="btn-group" role="group" aria-label="Basic example">' + buttons + '</div>';
    }
}

var Strings = {
    IsNullOrUndefinedOrEmpty: function (value) {
        return (value == null || value == undefined || value == '');
    },
    GetDefaultIfNullOrUndefinedOrEmpty: function (value, defaultValue) {
        if (value == null || value == undefined || value == '') {
            return defaultValue;
        } else {
            return value;
        }
    }
}

var Texts = {
    "Insert": CurrentLang == "A" ? "اضافة" : "Insert",
    "Update": CurrentLang == "A" ? "تعديل" : "Update",
}

var URLFunc = {
    Get: function (key) {
        let url = new URL(window.location.href);
        return url.searchParams.get(key);
    },
    Set: function (key, value) {
        let url = new URL(window.location.href);
        url.searchParams.set(key, value);
        window.history.pushState({ path: url.href }, '', url.href);
    }
}

var ImageProccess = {
    dataURLtoFile: function (dataurl, filename) {
        var arr = dataurl.split(','), mime = arr[0].match(/:(.*?);/)[1],
            bstr = atob(arr[1]), n = bstr.length, u8arr = new Uint8Array(n);
        while (n--) {
            u8arr[n] = bstr.charCodeAt(n);
        }
        return new File([u8arr], filename, { type: mime });
    },
    toDataURL: url => fetch(url)
        .then(response => response.blob())
        .then(blob => new Promise((resolve, reject) => {
            const reader = new FileReader()
            reader.onloadend = () => resolve(reader.result)
            reader.onerror = reject
            reader.readAsDataURL(blob)
        }))
}
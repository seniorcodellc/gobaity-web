const baseUrl = "/api/GroupPermissions";
$(function () {
    let columns = [
        { 'data': 'pageId', 'name': 'pageId' },
        { 'data': 'page' + CurrentLang +'name', 'name': 'page' + CurrentLang + 'name' },
        {
            "orderable": false, "data": null, "render": function (data, type, row) {
                console.log(row);
                return "  <button onclick='TogglePermission(`" + data.pageId + "`)'   class='btn btn-" + (data.state=='True' ? "info" : "danger") + "'><i class='mdi mdi-checkbox-blank-circle'></i></button>";
            }
        }
    ];

    Ajax.LoadDropDown('group', '/api/Groups', 'groupId', 'groupAname', 'groupEname');
    Ajax.LoadDropDown('tab', '/api/PagesTabs', 'pagesTabId', 'pagesTabAname', 'pagesTabEname');

    $('#group,#tab').change(function () {
        let groupId = $('#group').val();
        let tabId = $('#tab').val();

        $('#tblData').DataTable().destroy();
        $('#tblData tbody').remove();
        

        if (groupId != '' && tabId != '') {
            Ajax.LoadDataTable('#tblData', baseUrl + '/LoadDataTable/' + groupId + '/' + tabId, columns);
        }
    })
})

function TogglePermission(pageId) {
    Ajax.Post((baseUrl + '/' + pageId + '/' + $('#group').val()), {},'POST', (e) => {
        Alert.Message(e);
    }, () => {
        Alert.Error()
    }, () => {
        Ajax.RefrishDataTable();
    });
} 
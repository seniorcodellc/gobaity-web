const baseUrl = "/api/Groups";
$(function () {
    let columns = [
        { 'data': 'serial', 'name': 'serial' },
        { 'data': 'group' + CurrentLang + 'name', 'name': 'group' + CurrentLang +'name' }, 
        {
            "orderable": false, "data": null, "render": function (data, type, row) {
                return Buttons.Group(Buttons.Delete(baseUrl + '/' + row.groupId) + Buttons.Update(row.groupId) + Buttons.Active((baseUrl + '/Active/' + row.groupId), row.isActive));
            }
        }
    ];

    Ajax.LoadDataTable('#tblData', baseUrl + '/LoadDataTable', columns); 
})
 
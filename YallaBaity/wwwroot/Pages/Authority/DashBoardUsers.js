const baseUrl = "/api/DashBoardUsers";
$(function () {
    let columns = [
        { 'data': 'serial', 'name': 'serial' },
        { 'data': 'userName', 'name': 'userName' },
        { 'data': 'email', 'name': 'email' },
        { 'data': 'group' + CurrentLang + 'name', 'name': 'group' + CurrentLang + 'name' },
        {
            "orderable": false, "data": null, "render": function (data, type, row) {
                return Buttons.Group(Buttons.Delete(baseUrl + '/' + row.userId) + Buttons.Update(row.userId) + Buttons.Active((baseUrl + '/Active/' + row.userId), row.isActive));
            }
        }
    ];

    Ajax.LoadDataTable('#tblData', baseUrl + '/LoadDataTable', columns);
})
 

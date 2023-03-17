const baseUrl = "/api/Users";
$(function () {
    let columns = [
        { 'data': 'serial', 'name': 'serial' },
        { 'data': 'userName', 'name': 'userName' },
        { 'data': 'phone', 'name': 'phone' },
        { 'data': 'governorate' + CurrentLang + 'name', 'name': 'governorate' + CurrentLang + 'name' },
        {
            "orderable": false, "data": null, "render": function (data, type, row) {
                return Buttons.Group(Buttons.Delete(baseUrl + '/' + row.userId) + Buttons.View(row.userId) + Buttons.Active((baseUrl + '/Active/' + row.userId), row.isActive));
            }
        }
    ];

    Ajax.LoadDataTable('#tblData', baseUrl + '/LoadDataTable?usersType=proviters', columns);
})

 

 
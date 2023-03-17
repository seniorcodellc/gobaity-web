const baseUrl = "/api/Categories";
$(function () {
    let columns = [
        { 'data': 'serial', 'name': 'serial' },
        { 'data': 'category' + CurrentLang + 'name', 'name': 'category' + CurrentLang + 'name' }, 
        { 'data': 'category' + CurrentLang + 'description', 'name': 'category' + CurrentLang + 'description' }, 
        {
            "orderable": false, "data": null, "render": function (data, type, row) { 
                return Buttons.Group(Buttons.Delete(baseUrl+'/' + row.categoryId) + Buttons.Update(row.categoryId) + Buttons.Active((baseUrl + '/Active/' + row.categoryId), row.isActive));
            }
        }
    ];

    Ajax.LoadDataTable('#tblData', baseUrl + '/LoadDataTable', columns); 
})

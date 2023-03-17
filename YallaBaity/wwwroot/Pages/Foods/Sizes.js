const baseUrl = "/api/Sizes";
$(function () {
    let columns = [
        { 'data': 'serial', 'name': 'serial' },
        { 'data': 'size' + CurrentLang + 'name', 'name': 'size' + CurrentLang +'name' }, 
        {
            "orderable": false, "data": null, "render": function (data, type, row) {
                return Buttons.Group(Buttons.Delete(baseUrl + '/' + row.sizeId) + Buttons.Update(row.sizeId) + Buttons.Active((baseUrl + '/Active/' + row.sizeId), row.isActive));
            }
        }
    ];

    Ajax.LoadDataTable('#tblData', baseUrl + '/LoadDataTable', columns); 
})
  
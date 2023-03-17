const baseUrl = "/api/Foods";
$(function () {
    let columns = [
        { 'data': 'serial', 'name': 'serial' },
        { 'data': 'foodName', 'name': 'foodName' }, 
        { 'data': 'price', 'name': 'price' },  
        { 'data': 'cookName', 'name': 'cookName' },  
        {
            "orderable": false, "data": null, "render": function (data, type, row) {
                return Buttons.Group(Buttons.Delete(baseUrl + '/' + row.foodId) + Buttons.Update(row.foodId) + Buttons.Active((baseUrl + '/Active/' + row.foodId), row.isActive));
            }
        }
    ];

    Ajax.LoadDataTable('#tblData', baseUrl + '/LoadDataTable?isPending=true', columns); 
})

 
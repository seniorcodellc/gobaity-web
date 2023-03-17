const baseUrl = "/api/Users";
$(function () {
    let columns = [
        { 'data': 'serial', 'name': 'serial' },
        { 'data': 'userName', 'name': 'userName' },
        { 'data': 'phone', 'name': 'phone' },
        { 'data': 'governorate' + CurrentLang + 'name', 'name': 'governorate' + CurrentLang + 'name' },
        {
            "orderable": false, "data": null, "render": function (data, type, row) {
                return Buttons.Group(Buttons.Delete(baseUrl + '/' + row.userId) + Buttons.Approval(row.userId) + Buttons.View(row.userId));
            }
        }
    ];

    Ajax.LoadDataTable('#tblData', baseUrl + '/LoadDataTable?usersType=pending', columns);
})

 

function Approval(id) {
    Ajax.Post(baseUrl + '/ApproveProvider?id=' + id, {}, (e) => { Alert.Message(e); }, () => { Alert.Error() }, () => { Ajax.RefrishDataTable(); });
}
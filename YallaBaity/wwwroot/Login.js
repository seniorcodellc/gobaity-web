$(function () {
    $('#Form input').on('blur', function (e) {
        Control.Validate('Form', (e.target.id));
    });
})

function Login() {
    if (Control.Validate('Form')) {
        Ajax.Post('/api/DashBoardUsers/Login', Control.GetElemntAsObject('Form'),'POST', (e) => {
            Alert.Message(e);
            if (e.state) {
                location.href = '/DashBoard/Home';
            }
        }, () => {
            Alert.Error();
        }, () => {

        });
    }
}
$(function () {
    RadioButtonEvent();

    let target = URLFunc.Get('target');
    if (target == 'register') {
        $('#SignInRegister').show();
        $('#SignInLogin').hide();
    } else    {
        $('#SignInRegister').hide();
        $('#SignInLogin').show();
    }  

    $('#lnkOpenLogin').click(function () {
        $('#SignInRegister').slideUp(500);
        $('#SignInLogin').slideDown(500);
        URLFunc.Set('target', 'login');
    })

    $('#lnkOpenRegister').click(function () {
        $('#SignInRegister').slideDown(500);
        $('#SignInLogin').slideUp(500);
        URLFunc.Set('target', 'register');
    })
      
    $('#SignInRegister input,#SignInRegister select,#SignInRegister input[type = checkbox]').on('blur', function (e) {
        Control.Validate('SignInRegister', (e.target.id));
    });

    $('#SignInLogin input,#SignInLogin select,#SignInLogin input[type = checkbox]').on('blur', function (e) {
        Control.Validate('SignInLogin', (e.target.id));
    });

    $('#btnConfirm').click(function () {
        let code = $('#txtCode1').val() + $('#txtCode2').val() + $('#txtCode3').val() + $('#txtCode4').val();
        Ajax.Post("/api/Users/CheckOTP/" + $('#userId').val() + "?code=" + code +"&login=true", {}, "POST", (e) => {
            Alert.Message(e);
            if (e.state) {
                location.href = '/Account/Profile';
            }
        }, () => {
            Alert.Error();
        }, () => { }); 
    });

    $('#btnLogin').click(function () {
        if (Control.Validate('SignInLogin')) {
            let userModel = {
                phone: $('#txtLoginPhone').val(),
                password: $('#txtLoginPassword').val(),
                login:true
            }

            Ajax.Post("/api/Users/Login", userModel, "POST", (e) => {
                Alert.Message(e);
                if (e.state) {
                    location.href = '/Account/Profile';
                }
            }, () => {
                Alert.Error();
            }, () => { });
        } 
    });

    $('#btnRegister').click(function () { 
        if (Control.Validate('SignInRegister')) {
            let userModel = {
                userName: $('#txtRegisterName').val(),
                password: $('#txtRegisterPassword').val(),
                phone: $('#txtRegisterPhone').val(),
                gender: $('#txtRegisterGenderMale').prop('checked'),
            }
             
            let form = new FormData();
            form.append('userName', userModel.userName);
            form.append('password', userModel.password);
            form.append('phone', userModel.phone);
            form.append('gender', userModel.gender);

            Ajax.PostForm("/api/Users", form, "POST", (e) => {
                Alert.Message(e);
                if (e.state) {
                    $('#txtRegisterName').val('');
                    $('#txtRegisterPassword').val('');
                    $('#txtRegisterPhone').val('');
                    $('#userId').val(e.data.userId);
                    Ajax.Post("/api/Users/SendOTP/" + e.data.userId, {}, "POST", (e) => {
                        if (e.state) {
                            OpenConfirmation();
                        }
                    }, () => {
                        Alert.Error();
                    }, () => { });
                }
            }, () => {
                Alert.Error();
            }, () => { });
        }
    });
      
    $('.confirmCode input').keyup(function () {
        let target = $(this).attr('data-target');
        if ($(this).val() < 9) {
            if (target == undefined) {
                if ($('#txtCode1').val() != "" && $('#txtCode2').val() != "" && $('#txtCode3').val() != "" && $('#txtCode4').val() != "") {
                    $('#btnConfirm').click();
                }
            } else {
                $(target).focus();
            }
        }
    }) 
})

function OpenConfirmation() {
    $('#SignInRegister').slideUp(500); 
    $('#SignInConfirmCode').slideDown(500);
}

//=========================================== Remember Password Form - Start ===========================================//
$('#rememberPassword_form').submit( (event) => {

    event.preventDefault();

    let userEmail = $("#pass_email").val()

    let html = ``

    $.ajax({
        url: './remember-password-servlet?userEmail=' + userEmail,
        type: 'get',
        dataType: 'JSON',
        success: function (data) {
            console.log(data)
            let error = "Bu E-mail adresine ait hesap bulunmamaktadır."
            if ( data != null && data != "0" ) {
                html = `<div class="alert alert-success alert-dismissible fade show" role="alert">
                            <strong style="color: black">${data}</strong>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                `
                $("#pass_success").html(html)
            } else{

                html = `<div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <strong style="color: black"> Şifre: ${error}</strong>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                `
                $("#pass_fail").html(html)
            }
        },
        error: function (err) {
            console.log(err)
            alert("İşlem sırısında bir hata oluştu!");
        }
    })

})
//=========================================== Remember Password Form - End ===========================================//



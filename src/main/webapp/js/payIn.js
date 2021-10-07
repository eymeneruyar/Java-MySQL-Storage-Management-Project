
let select_id = 0;

//=========================================== Add Payment Section - Start ===========================================//
$('#payIn_form').submit( (event) => {

    event.preventDefault()

    const cnamePayIn = $('#cnamePayIn').val()
    const cuTicketNoPayIn = $('#cuTicketNoPayIn').val()
    const payInTotal = $('#payInTotal').val()
    const payInDetail = $('#payInDetail').val()

    const obj = {
        cbIn_customer: cnamePayIn,
        cbIn_ticketNo: cuTicketNoPayIn,
        cbIn_payAmount: payInTotal,
        cbIn_payDetail: payInDetail
    }

    if ( select_id != 0 ) {
        // update
        obj["cbIn_id"] = select_id;
    }
    $.ajax({
        url: './payIn-insert',
        type: 'POST',
        data: { obj: JSON.stringify(obj) },
        dataType: 'JSON',
        success: function (data) {
            if ( data > 0 ) {
                alert("İşlem Başarılı")
                fncReset()
            }else {
                alert("İşlem sırasında hata oluştu!");
            }
        },
        error: function (err) {
            console.log(err)
            alert("İşlem sırısında bir hata oluştu!");
        }
    })



} )

//=========================================== Add Payment Section - End ===========================================//

//=========================================== All Payment Section - Start ===========================================//
function allPayment(){

    $.ajax({
        url:"./payIn-allPayment",
        type: "get",
        dataType: "json",
        success: function (data){
            paymentTable(data)
        },
        error: function (err){
            console.log(err)
        }
    })

}
allPayment()

//=========================================== All Payment Section - End ===========================================//

//=========================================== All Payment Table Section - Start ===========================================//

let globalArray = {}
function paymentTable(data){
    let html = ``
    for (let i = 0; i < data.length; i++) {
        globalArr = data
        const itm = data[i]
        html += `<tr role="row" class="odd">
                        <td>${itm[0]}</td>
                        <td>${itm[1]}</td>
                        <td>${itm[2]}</td>
                        <td>${itm[3]}</td>
                        <td class="text-right" >
                            <div class="btn-group" role="group" aria-label="Basic mixed styles example">
                                <button onclick="fncPaymentDelete(`+itm[0]+`)" type="button" class="btn btn-outline-primary "><i class="far fa-trash-alt"></i></button>
                                <button onclick="fncPaymentDetail(`+i+`)" data-bs-toggle="modal" data-bs-target="#paymentDetailModel" type="button" class="btn btn-outline-primary "><i class="far fa-file-alt"></i></button>
                                
                            </div>
                        </td>
                    </tr>`
    }
    $("#paymentTable").html(html)
}

//=========================================== All Payment Table Section - End ===========================================//

//=========================================== Payment Delete Section - Start ===========================================//

function fncPaymentDelete(cbIn_id){
    let answer = confirm("Silmek istediğinize emin misiniz?")
    if(answer){

        $.ajax({
            url:"./payIn-deletePayment?cbIn_id=" + cbIn_id,
            type:"delete",
            dataType: 'text',
            success: function (data){
                if( data != "0" ){
                    fncReset()
                }else {
                    alert("Silme sırasında bir hata oluştu.")
                }
            },
            error: function (err){
                console.log(err)
            }
        })
    }
}

//=========================================== Payment Delete Section - End ===========================================//

//=========================================== Payment Detail Section - Start ===========================================//

function fncPaymentDetail(i){

    const itm = globalArr[i]
    $("#cb_customerDetail").text(itm[1] + "-" + itm[0]);
    $("#cb_ticketNoDetail").text(itm[2] == "" ? '------' : itm[2]);
    $("#cb_payAmount").text(itm[3] == "" ? '------' : itm[3]);
    $("#cb_payAmountDetail").text(itm[4] == "" ? '------' : itm[4]);

}

//=========================================== Payment Detail Section - End ===========================================//

//=========================================== Payment Update Section - Start ===========================================//

function fncPaymentUpdate(i){
    const itm = globalArr[i];
    select_id = itm[0]
    $('#cnamePayIn').val(itm[1])
    $('#cuTicketNoPayIn').val(itm[2])
    $('#payInTotal').val(itm[3])
    $('#payInDetail').val(itm[4])
}

//=========================================== Payment Update Section - End ===========================================//

//=========================================== PayIn Search - Start ===========================================//

$('#payInSearch').keyup( function(event)  {

    //Keyup fonksiyonu ile backspace aktivitelerini de yakalayabildim.

    event.preventDefault();

    let csearch = $("#payInSearch").val()

    $.ajax({
        url: './payIn-search?csearch=' + csearch,
        type: 'get',
        dataType: 'json',
        success: function (dataSearch) {
            if ( dataSearch != null ) {
                /*
                * Burada servlet tarafından dönen data string formatta olduğu için
                * JSON formata çevirmemiz gerekmektedir.
                */
                console.log(dataSearch)
                paymentSearchTable(dataSearch)
            }else {
                allPayment()
            }
        },
        error: function (err) {
            console.log(err)
            alert("İşlem sırısında bir hata oluştu!");
        }
    })

})

//=========================================== PayIn Search - End ===========================================//

//=========================================== Function Reset Section - Start ===========================================//
function fncReset(){
    select_id = 0
    $("#payIn_form").trigger("reset")
    allPayment()
}
//=========================================== Function Reset Section - End ===========================================//

//=========================================== All Payment Search Section - Start ===========================================//

function paymentSearchTable(data){
    let html = ``
    for (let i = 0; i < data.length; i++) {
        globalArr = data
        const itm = data[i]
        html += `<tr role="row" class="odd">
                        <td>${itm.cbIn_id}</td>
                        <td>${itm.co_nameSurname}</td>
                        <td>${itm.co_ticketNo}</td>
                        <td>${itm.cbIn_payAmount}</td>
                        <td class="text-right" >
                            <div class="btn-group" role="group" aria-label="Basic mixed styles example">
                                <button onclick="fncPaymentDelete(`+itm.cbIn_id+`)" type="button" class="btn btn-outline-primary "><i class="far fa-trash-alt"></i></button>
                                <button onclick="fncPaymentSearchDetail(`+i+`)" data-bs-toggle="modal" data-bs-target="#paymentDetailModel" type="button" class="btn btn-outline-primary "><i class="far fa-file-alt"></i></button>
                                <button onclick="fncPaymentSearchUpdate(`+i+`)" type="button" class="btn btn-outline-primary "><i class="fas fa-pencil-alt"></i></button>
                            </div>
                        </td>
                    </tr>`
    }
    $("#paymentTable").html(html)
}

function fncPaymentSearchDetail(i){

    const itm = globalArr[i]
    $("#cb_customerDetail").text(itm.co_nameSurname + "-" + itm.cbIn_id);
    $("#cb_ticketNoDetail").text(itm.co_ticketNo == "" ? '------' : itm.co_ticketNo);
    $("#cb_payAmount").text(itm.cbIn_payAmount == "" ? '------' : itm.cbIn_payAmount);
    $("#cb_payAmountDetail").text(itm.cbIn_payDetail == "" ? '------' : itm.cbIn_payDetail);

}

function fncPaymentSearchUpdate(i){
    const itm = globalArr[i];
    select_id = itm.cbIn_id
    $('#cnamePayIn').val(itm.co_nameSurname)
    $('#cuTicketNoPayIn').val(itm.co_ticketNo)
    $('#payInTotal').val(itm.cbIn_payAmount)
    $('#payInDetail').val(itm.cbIn_payAmount)
}

//=========================================== All Payment Search Section - End ===========================================//




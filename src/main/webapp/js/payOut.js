let select_id = 0;

//=========================================== Add Payment Out Section - Start ===========================================//
$('#payOut_form').submit( (event) => {

    event.preventDefault()

    const payOutTitle = $('#payOutTitle').val()
    const payOutType = $('#payOutType').val()
    const payOutTotal = $('#payOutTotal').val()
    const payOutDetail = $('#payOutDetail').val()

    const obj = {
        cbOut_title: payOutTitle,
        cbOut_payType: payOutType,
        cbOut_payAmount: payOutTotal,
        cbOut_payDetail: payOutDetail
    }

    if ( select_id != 0 ) {
        // update
        obj["cbOut_id"] = select_id;
    }
    $.ajax({
        url: './payOut-insert',
        type: 'POST',
        data: { obj: JSON.stringify(obj) },
        dataType: 'JSON',
        success: function (data) {
            if ( data > 0 ) {
                console.log(data)
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

//=========================================== Add Payment Out Section - End ===========================================//

//=========================================== All Payment Section - Start ===========================================//
function allPaymentOut(){

    $.ajax({
        url:"./payOut-allPayment",
        type: "get",
        dataType: "json",
        success: function (data){
            console.log(data)
            paymentOutTable(data)
        },
        error: function (err){
            console.log(err)
        }
    })

}
allPaymentOut()

//=========================================== All Payment Section - End ===========================================//

//=========================================== All Payment Out Table Section - Start ===========================================//

let globalArray = {}
function paymentOutTable(data){
    let html = ``
    for (let i = 0; i < data.length; i++) {
        globalArr = data
        const itm = data[i]
        const payType = itm.cbOut_payType == 0 ? "Nakit" : itm.cbOut_payType == 1 ? "Kredi Kartı" : itm.cbOut_payType == 2 ? "Havale"
            : itm.cbOut_payType == 3 ? "EFT" : "Banka Çeki"
        html += `<tr role="row" class="odd">
                        <td>${itm.cbOut_id}</td>
                        <td>${itm.cbOut_title}</td>
                        <td>${payType}</td>
                        <td>${itm.cbOut_payDetail}</td>
                        <td>${itm.cbOut_payAmount}</td>
                        <td class="text-right" >
                            <div class="btn-group" role="group" aria-label="Basic mixed styles example">
                                <button onclick="fncPaymentOutDelete(`+itm.cbOut_id+`)" type="button" class="btn btn-outline-primary "><i class="far fa-trash-alt"></i></button>
                                <button onclick="fncPaymentOutDetail(`+i+`)" data-bs-toggle="modal" data-bs-target="#paymentOutDetailModel" type="button" class="btn btn-outline-primary "><i class="far fa-file-alt"></i></button>
                                <button onclick="fncPaymentUpdate(`+i+`)" type="button" class="btn btn-outline-primary "><i class="fas fa-pencil-alt"></i></button>
                            </div>
                        </td>
                    </tr>`
    }
    $("#paymentOutTable").html(html)
}

//=========================================== All Payment Out Table Section - End ===========================================//

//=========================================== Payment Out Delete Section - Start ===========================================//

function fncPaymentOutDelete(cbOut_id){
    let answer = confirm("Silmek istediğinize emin misiniz?")
    if(answer){

        $.ajax({
            url:"./payOut-deletePayment?cbOut_id=" + cbOut_id,
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

//=========================================== Payment Out Delete Section - End ===========================================//

//=========================================== Payment Out Detail Section - Start ===========================================//

function fncPaymentOutDetail(i){

    const itm = globalArr[i]
    const payType = itm.cbOut_payType == 0 ? "Nakit" : itm.cbOut_payType == 1 ? "Kredi Kartı" : itm.cbOut_payType == 2 ? "Havale"
        : itm.cbOut_payType == 3 ? "EFT" : "Banka Çeki"
    $("#paymentOutDetail").text(itm.cbOut_id + "-" + itm.cbOut_title);
    $("#payTypeDetail").text(payType == "" ? '------' : payType);
    $("#payAmountOut").text(itm.cbOut_payAmount == "" ? '------' : itm.cbOut_payAmount);
    $("#payAmountDetail").text(itm.cbOut_payDetail == "" ? '------' : itm.cbOut_payDetail);

}

//=========================================== Payment Out Detail Section - End ===========================================//

//=========================================== Payment Out Update Section - Start ===========================================//

function fncPaymentUpdate(i){
    const itm = globalArr[i];
    select_id = itm.cbOut_id
    $('#payOutTitle').val(itm.cbOut_title)
    $('#payOutType').val(itm.cbOut_payType)
    $('#payOutTotal').val(itm.cbOut_payAmount)
    $('#payOutDetail').val(itm.cbOut_payDetail)
}

//=========================================== Payment Out Update Section - End ===========================================//

//=========================================== PayOut Search - Start ===========================================//

$('#payOutSearch').keyup( function(event)  {

    //Keyup fonksiyonu ile backspace aktivitelerini de yakalayabildim.

    event.preventDefault();

    let csearch = $("#payOutSearch").val()

    $.ajax({
        url: './payOut-search?csearch=' + csearch,
        type: 'get',
        dataType: 'text',
        success: function (dataSearch) {
            if ( dataSearch != null ) {
                globalArr = []
                /*
                * Burada servlet tarafından dönen data string formatta olduğu için
                * JSON formata çevirmemiz gerekmektedir.
                */
                const obj = JSON.parse(dataSearch)
                paymentOutTable(obj)
            }else {
                allPaymentOut()
            }
        },
        error: function (err) {
            console.log(err)
            alert("İşlem sırısında bir hata oluştu!");
        }
    })

})

//=========================================== PayOut Search - End ===========================================//

//=========================================== Function Reset Section - Start ===========================================//
function fncReset(){
    select_id = 0
    $("#payOut_form").trigger("reset")
    allPaymentOut()
}
//=========================================== Function Reset Section - End ===========================================//










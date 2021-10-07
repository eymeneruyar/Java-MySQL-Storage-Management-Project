
//=========================================== New Sale Insert Section - Start ===========================================//
$("#sale_add_form").submit((event) => {

    event.preventDefault()

    const cnameSelect = $("#cnameSelect").val()
    const pnameSelect = $("#pnameSelect").val()
    const count = $("#count").val()
    const bNo = $("#bNo").val()

    const obj = {
        bo_customer: cnameSelect,
        bo_product: pnameSelect,
        bo_total: count,
        bo_ticketNo: bNo
    }

    $.ajax({
        url: "./sale-add",
        type: "post",
        data: { obj:JSON.stringify(obj)},
        dataType: "json",
        success: function (data){
            if(data > 0){
                fncReset()
                allSale(cnameSelect)
                alert("İşlem başarılı")
            }else {
                alert("İşlem sırısında bir hata oluştu!")
            }
        },
        error: function (err){
            console.log(err)
            alert("İşlem sırısında bir hata oluştu!")
        }
    })

})
//=========================================== New Sale Insert Section - End ===========================================//

//=========================================== All Sale List Section - Start ===========================================//
function allSale(cu_id){
    $.ajax({
        url: "./sale-list?cu_id=" + cu_id,
        type: "get",
        dataType: "json",
        success: function (data){
            createSalesTable(data)
            allSaleTotalPrice(cu_id)
        },
        error: function (err){
            console.log(err)
        }
    })
}
//=========================================== All Sale List Section - End ===========================================//

//=========================================== All Sales Table Section - Start ===========================================//
let globalArr = []
function createSalesTable(data){
    let html = ``
    for (let i = 0; i < data.length; i++) {
        globalArr = data
        const item = data[i]
        html += `<tr role="row" class="odd">
                        <td>${item.bo_id}</td>
                        <td>${item.p_title}</td>
                        <td>`+item.p_salePrice+`</td>
                        <td>`+item.bo_total+`</td>
                        <td>`+item.name_surname+`</td>
                        <td>`+item.bo_totalPrice+`</td>
                        <td>`+item.bo_ticketNo+`</td>
                        <td class="text-right" >
                            <div class="btn-group" role="group" aria-label="Basic mixed styles example">
                                <button onclick="fncSaleDelete(`+item.bo_id+`)" type="button" class="btn btn-outline-primary "><i class="far fa-trash-alt"></i></button>
                            </div>
                        </td>
                    </tr>`
        $("#bNo").val(item.bo_ticketNo) //Eğer kullanıcının sepette ürünü varsa zaten bulunan fiş numarasını "Fiş No" bölümüne yazar.
    }
    $("#salesTable").html(html)
}
//=========================================== All Sales Table Section - End ===========================================//

//=========================================== Sale Delete Section - Start ===========================================//

function fncSaleDelete(bo_id){
    let answer = confirm("Silmek istediğinize emin misiniz?")
    if (answer) {
        let c_id = $('#cnameSelect').val()
        $.ajax({
            url: "./sale-delete?bo_id=" + bo_id,
            type: "delete",
            dataType: 'text',
            success: function (data) {
                console.log(typeof data)
                if (data != "0") {
                    fncReset()
                    allSale(c_id)
                } else {
                    alert("Silme sırasında bir hata oluştu.")
                }
            },
            error: function (err) {
                console.log(err)
            }
        })
    }
}


//=========================================== Sale Delete Section - End ===========================================//

//=========================================== Function Reset Section - Start ===========================================//
function fncReset(){
    //$("#sale_add_form").trigger("reset")
    $("#pnameSelect").val("")
    $("#count").val("")
}
//=========================================== Function Reset Section - End ===========================================//

//=========================================== Get cnameSelect Value - Start ===========================================//
$("#cnameSelect").on("change",function (){
    allSale(this.value)
    allSaleTotalPrice(this.value)
})
//=========================================== Get cnameSelect Value - End ===========================================//

//=========================================== Code Generator - Start ===========================================//
function codeGenerator(){
    const date = new Date();
    const time = date.getTime();
    const key = time.toString().substring(4);
    $("#bNo").val(key)
}
codeGenerator()
//=========================================== Code Generator - End ===========================================//

//=========================================== Completed Order - Start ===========================================//
function fncCompletedOrder(){

    let customer_id = $("#cnameSelect").val()
    let answer = confirm("Satış işlemi onaylansın mı?");

    if(answer){
        $.ajax({
            url: "./completed-order?customer_id=" + customer_id,
            type: "get",
            dataType: 'text',
            success: function (data) {
                console.log(typeof data)
                if (data != "0") {
                    alert("Satış işlemi başarılı!")
                    //All Forms Reset Process - Start
                    $("#pnameSelect").val("")
                    $("#count").val("")
                    codeGenerator()
                    //All Forms Reset Process - End
                    allSale(customer_id)
                } else {
                    alert("Satış tamamlanırken bir hata oluştu.")
                }
            },
            error: function (err) {
                console.log(err)
            }
        })
    }

}
//=========================================== Completed Order - End ===========================================//

//=========================================== Total Price Box - Start ===========================================//
function allSaleTotalPrice(cu_id){
    $.ajax({
        url: "./price-box?cu_id=" + cu_id,
        type: "get",
        dataType: "text",
        success: function (data){
            let html = `<strong> `+data+`  ₺ </strong>`
            $("#totalPrice").html(html)
        },
        error: function (err){
            console.log(err)
        }
    })

}
//=========================================== Total Price Box - End ===========================================//



let select_id = 0

//=========================================== Product Insert Section - Start ===========================================//
$("#product_add_form").submit( (event) => {

    event.preventDefault()

    const ptitle = $("#ptitle").val()
    const aprice = $("#aprice").val()
    const oprice = $("#oprice").val()
    const pcode = $("#pcode").val()
    const ptax = $("#ptax").val()
    const psection = $("#psection").val()
    const size = $("#size").val()
    const pdetail = $("#pdetail").val()

    const obj = {
        p_title: ptitle,
        p_buyPrice: aprice,
        p_salePrice: oprice,
        p_code: pcode,
        p_vat: ptax,
        p_unit: psection,
        p_quantity: size,
        p_detail: pdetail
    }

    if(select_id != 0){
        //Update
        obj["p_id"] = select_id
    }
    $.ajax({
        url: "./product-insert",
        type: "post",
        data:{ obj:JSON.stringify(obj)},
        dataType: "json",
        success: function (data){
            if (data > 0) {
                fncReset()
                alert("İşlem başarılı")
            } else {
                alert("İşlem sırısında bir hata oluştu!")
            }
        },
        error: function (err){
            console.log(err)
            alert("İşlem sırısında bir hata oluştu!")
        }
    })

})
//=========================================== Product Insert Section - End ===========================================//

//=========================================== All Product List Section - Start ===========================================//
function allProduct(){
    $.ajax({
        url: "./product-all",
        type: "get",
        dataType: "json",
        success: function (data){
            createTable(data)
        },
        error: function (err){
            console.log(err)
        }
    })
}
allProduct()
//=========================================== All Product List Section - End ===========================================//

//=========================================== All Product Table Section - Start ===========================================//
let globalArr = []
function createTable(data){
    let html = ``
    for (let i = 0; i < data.length; i++) {
        globalArr = data
        const itm = data[i]
        const stTax = itm.p_vat == 0 ? "Dahil" : itm.p_vat == 1 ? "%1"
            : itm.p_vat == 2 ? "%8" : "%18"
        const stUnit = itm.p_unit == 0 ? "Adet" : itm.p_unit == 1 ? "KG" : itm.p_unit == 2 ? "Metre"
            : itm.p_unit == 3 ? "Paket" : "Litre"
        html += `<tr role="row" class="odd">
                        <td>`+itm.p_id+`</td>
                        <td>`+itm.p_title+`</td>
                        <td>`+itm.p_buyPrice+`</td>
                        <td>`+itm.p_salePrice+`</td>
                        <td>`+itm.p_code+`</td>
                        <td>`+stTax+`</td>
                        <td>`+stUnit+`</td>
                        <td>`+itm.p_quantity+`</td>
                        <td class="text-right" >
                            <div class="btn-group" role="group" aria-label="Basic mixed styles example">
                                <button onclick="fncProductDelete(`+itm.p_id+`)" type="button" class="btn btn-outline-primary "><i class="far fa-trash-alt"></i></button>
                                <button onclick="fncProductDetail(`+i+`)" type="button" class="btn btn-outline-primary " data-bs-toggle="modal" data-bs-target="#productDetailModal"><i class="far fa-file-alt"></i></button>
                                <button onclick="fncProductUpdate(`+i+`)" type="button" class="btn btn-outline-primary "><i class="fas fa-pencil-alt"></i></button>
                            </div>
                        </td>
                    </tr>`
    }
    $("#productTable").html(html)
}
//=========================================== All Product Table Section - End ===========================================//

//=========================================== Product Delete Section - Start ===========================================//
function fncProductDelete(p_id){
    let answer = confirm("Silmek istediğinize emin misiniz?")
    if(answer){

        $.ajax({
            url: "./product-delete?p_id=" + p_id,
            type: "delete",
            dataType: "text",
            success: function (data){
                if(data != "0"){
                    fncReset()
                }else {
                    alert("Silme işlemi sırasında bir hata oluştu.")
                }
            },
            error: function (err){
                console.log(err)
            }
        })

    }
}
//=========================================== Product Delete Section - End ===========================================//

//=========================================== Product Detail Section - Start ===========================================//
function fncProductDetail(i){
    const itm = globalArr[i]
    const stTax = itm.p_vat == 0 ? "Dahil" : itm.p_vat == 1 ? "%1"
        : itm.p_vat == 2 ? "%8" : "%18"
    const stUnit = itm.p_unit == 0 ? "Adet" : itm.p_unit == 1 ? "KG" : itm.p_unit == 2 ? "Metre"
        : itm.p_unit == 3 ? "Paket" : "Litre"
    $("#p_title").text(itm.p_title)
    $("#p_buyPrice").text(itm.p_buyPrice)
    $("#p_salePrice").text(itm.p_salePrice)
    $("#p_code").text(itm.p_code)
    $("#p_vat").text(stTax)
    $("#p_unit").text(stUnit)
    $("#p_quantity").text(itm.p_quantity)
    $("#p_detail").text(itm.p_detail == "" ? "------" : itm.p_detail)
}
//=========================================== Product Detail Section - End ===========================================//

//=========================================== Product Update Section - Start ===========================================//
function fncProductUpdate(i){
    const itm = globalArr[i]
    select_id = itm.p_id
    $("#ptitle").val(itm.p_title)
    $("#aprice").val(itm.p_buyPrice)
    $("#oprice").val(itm.p_salePrice)
    $("#pcode").val(itm.p_code)
    $("#ptax").val(itm.p_vat)
    $("#psection").val(itm.p_unit)
    $("#size").val(itm.p_quantity, )
    $("#pdetail").val(itm.p_detail)
}
//=========================================== Product Update Section - End ===========================================//

//=========================================== Product Search - Start ===========================================//

$('#psearch').keyup( function(event)  {

    //Keyup fonksiyonu ile backspace aktivitelerini de yakalayabildim.

    event.preventDefault();

    let psearch = $("#psearch").val()

    $.ajax({
        url: './product-search?psearch=' + psearch,
        type: 'get',
        dataType: 'text',
        success: function (dataSearch) {
            console.log(dataSearch)
            if ( dataSearch != null ) {
                /*
                * Burada servlet tarafından dönen data string formatta olduğu için
                * JSON formata çevirmemiz gerekmektedir.
                */
                const obj = JSON.parse(dataSearch)
                createTable(obj)
            }else {
                allProduct()
            }
        },
        error: function (err) {
            console.log(err)
            alert("İşlem sırısında bir hata oluştu!");
        }
    })

})


//=========================================== Product Search - End ===========================================//


//=========================================== Function Reset Section - Start ===========================================//
function fncReset(){
    select_id = 0
    $("#product_add_form").trigger("reset")
    codeGenerator()
    allProduct()
}
//=========================================== Function Reset Section - End ===========================================//

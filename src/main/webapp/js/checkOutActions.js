
//=========================================== Report and Search Form Section - Start ===========================================//
$('#reportForm').submit( (event) => {

    event.preventDefault()

    const cnameSelect = $('#cnameSelect').val()
    const processType = $('#processType').val()
    const startDate = $('#startDate').val()
    const endDate = $('#endDate').val()

    const obj = {
        cu_id: cnameSelect,
        cbIn_status: processType,
        COA_startDate: startDate,
        COA_endDate: endDate
    }

    $.ajax({
        url: "./COAReport",
        type: "post",
        data: {obj:JSON.stringify(obj)},
        dataType: "json",
        success: function (data){
            if(cnameSelect == -1 && processType == 2){
                reportOutTable(data)
            }else if(cnameSelect != -1 && processType == 1){
                reportTable(data)
            }else{
                reportTable(data)
            }
            console.log(data)

        },
        error: function (err){
            console.log(err)
            alert("İşlem sırısında bir hata oluştu!")
        }
    })

} )
//=========================================== Report and Search Form Section - End ===========================================//

//=========================================== Report and Search Table Section - Start ===========================================//
let globalArr = []
function reportTable(data){
    let html = ``
    let htmlTitle = `<thead>
                    <tr>
                        <th>Fiş No</th>
                        <th>Müşteri</th>
                        <th>Telefon</th>
                        <th>Mail</th>
                        <th>Tür</th>
                        <th>Ödenen Tutar (₺)</th>
                    </tr>
                    </thead>`
    for (let i = 0; i < data.length; i++) {
        globalArr = data
        const itm = data[i]
        const stType = itm.paymentStatus == 1 ? "Giriş" : "----"
        html += `<tbody >
                    <!-- for loop  --> 
                    <tr role="row" class="odd">
                            <td>${itm.co_ticketNo}</td>
                            <td>${itm.co_nameSurname}</td>
                            <td>${itm.cu_mobile}</td>
                            <td>${itm.cu_email}</td>
                            <td>${stType}</td>
                            <td>${itm.co_amountPaid}</td>
                        </tr>
                 </tbody>`
    }
    $("#reportCOATable").html(html + htmlTitle)
}
//=========================================== Report and Search Table Section - End ===========================================//

//=========================================== Report and Search Box-Out Table Section - End ===========================================//
function reportOutTable(data){
    let html = ``
    let htmlTitle = `<thead>
                        <tr>
                            <th>Id</th>
                            <th>Başlık</th>
                            <th>Ödeme Detayı</th>
                            <th>Tür</th>
                            <th>Ödeme Tutarı (₺)</th>
                            <th>Ödeme Tarihi</th>
                        </tr>
                        </thead>`
    for (let i = 0; i < data.length; i++) {
        globalArr = data
        const itm = data[i]
        const stType = itm.cbOut_status == 2 ? "Çıkış" : "----"
        html += `<tbody >
                        <tr role="row" class="odd">
                            <td>${itm.cbOut_id}</td>
                            <td>${itm.cbOut_title}</td>
                            <td>${itm.cbOut_payDetail}</td>
                            <td>${stType}</td>
                            <td>${itm.cbOut_payAmount}</td>
                            <td>${itm.cbOut_date}</td>
                        </tr>
                </tbody>`
    }
    $("#reportCOAOutTable").html(html + htmlTitle)
}
//=========================================== Report and Search Box-Out Table Section - End ===========================================//

//=========================================== Report and Search Box-In Table Section - Start ===========================================//
function reportInTable(data){
    let html = ``
    for (let i = 0; i < data.length; i++) {
        globalArr = data
        const itm = data[i]
        const stType = itm.cbOut_status == 1 ? "Giriş" : "----"
        html += `
                        <tr role="row" class="odd">
                            <td>${itm.cbOut_id}</td>
                            <td>${itm.cbOut_title}</td>
                            <td>${itm.cbOut_payDetail}</td>
                            <td>${stType}</td>
                            <td>${itm.cbOut_payAmount}</td>
                            <td>${itm.cbOut_date}</td>
                        </tr>`
    }
    $("#reportCOAInTable").html(html)
}
//=========================================== Report and Search Box-In Table Section - End ===========================================//



















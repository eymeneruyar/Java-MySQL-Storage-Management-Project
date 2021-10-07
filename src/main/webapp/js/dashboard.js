
//=========================================== Product of Stock - Start ===========================================//
google.charts.load('current', {'packages':['bar']});
google.charts.setOnLoadCallback(drawStuff);

function drawStuff() {

    $.ajax({
        url: "./product-all",
        type: "get",
        dataType: "json",
        success: function (jsonData){

            var data = new google.visualization.DataTable()
            data.addColumn('string', 'Ürün');
            data.addColumn('number', 'Stok');
            for (var i = 0; i < jsonData.length; i++) {
                pTitle = jsonData[i].p_title;
                pQuantity = jsonData[i].p_quantity;
                data.addRows([[pTitle,pQuantity]])
            }

            var options = {
                title: 'Stok Ürünleri',
                legend: { position: 'none' },
                bars: 'horizontal', // Required for Material Bar Charts.
                axes: {
                    x: {
                        0: { side: 'top', label: 'Miktar'} // Top x-axis.
                    }
                },
                bar: { groupWidth: "100%" },
            };

            var chart = new google.charts.Bar(document.getElementById('top_x_div'));
            chart.draw(data, options);
        },
        error: function (err){
            console.log(err)
        }
    })


};
//=========================================== Product of Stock - End ===========================================//


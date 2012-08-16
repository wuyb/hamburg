/*function showTooltip(x, y, contents) {
  $('<div id="tooltip">' + contents + '</div>').css( {
    position: 'absolute',
    display: 'none',
    top: y + 5,
    left: x + 5,
    border: '1px solid #fdd',
    padding: '2px',
    'background-color': '#fee',
    opacity: 0.80
  }).appendTo("body").fadeIn(200);
}

function filterTransactionsByDate(startDate, endDate) {
    // query the server to get plot data
    var jqxhr = $.get("/transactions?by=day", function(json) {
      var incomes = [];
      var expenses = [];
      for (var key in json.income) {
        incomes.push([key, json.income[key].total]);
      }
      for (var key in json.expense) {
        expenses.push([key, json.expense[key].total]);
      }
      $.plot($("#transactions-by-time"), [{data: incomes, label: '收入'}, {data: expenses, label: '支出'}],  
      {
        xaxis: { mode: "time", timeformat: "%m月%d日"},
               series: {
                   lines: { show: true },
                   points: { show: true }
              },
               grid: { hoverable: true, clickable: true },
               bars: { show: true, barWidth: 60*60*12*1000, align: "center" }
      }
      );
    }, 'json').error(function(json) { 
      alert("error : " + json);
    });

}

$(document).ready(function() {

  if ($("#transactions-by-time").length > 0) {
    $('#filter_week').addClass('active');

    $("#transactions-by-time").bind("plothover", function (event, pos, item) {
      if (item) {

          $("#tooltip").remove();
          var x = item.datapoint[0].toFixed(2),
          y = item.datapoint[1].toFixed(2);

          showTooltip(item.pageX, item.pageY,
            item.series.label + " " + y + "元");
        }
      else {
        $("#tooltip").remove();
      }
    });
  }
});*/

$(document).ready(function() {
  if ($("#transactions-by-time").length > 0) {
    // query the server to get plot data
    var jqxhr = $.get("/transactions/plot?by=day", function(json) {
      var incomes = [];
      var expenses = [];
      for (var key in json.income) {
        incomes.push([key, json.income[key].total]);
      }
      for (var key in json.expense) {
        expenses.push([key, json.expense[key].total]);
      }
      console.log('incomes', incomes);
      console.log('expenses', expenses);
      $.plot($("#transactions-by-time"), [incomes, expenses],  
        {xaxis: {
          mode: "time",
          timeformat: "%m月%d日"
      }});
    }, 'json').error(function(json) { 
      alert("error : " + json);
    });
  }
});

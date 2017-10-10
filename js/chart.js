// Load the Visualization API and the corechart package.
google.charts.load('current', {'packages':['corechart']});

// Set a callback to run when the Google Visualization API is loaded.
google.charts.setOnLoadCallback(drawChart);

// Callback that creates and populates a data table,
// instantiates the pie chart, passes in the data and
// draws it.
function drawChart() {

// Create the data table.
var data = new google.visualization.DataTable();
data.addColumn('string', 'Sleep Stage');
data.addColumn('number', 'Number of Classified Values');
data.addRows([
  ['Stage 1', 100],
  ['Stage 2', 140],
  ['Stage 3', 35],
  ['Stage 4', 13],
  ['REM', 23]
]);

// Set chart options
var options = {
    'width':800,
    'height':600
};

// Instantiate and draw our chart, passing in some options.
var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
chart.draw(data, options);
}
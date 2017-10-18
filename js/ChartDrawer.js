// Load the Visualization API and the corechart package.
google.charts.load('current', {'packages':['corechart']});

// Set a callback to run when the Google Visualization API is loaded.
//google.charts.setOnLoadCallback(drawChart);
class ChartDrawer {
    // Callback that creates and populates a data table,
    // instantiates the pie chart, passes in the data and
    // draws it.
    drawChart(durationArray) {
        // Create the data table.
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Sleep Stage');
        data.addColumn('number', 'Number of Classified Values');
        data.addRows([
          ['N1', parseInt(durationArray[0])],
          ['N2', parseInt(durationArray[1])],
          ['N3', parseInt(durationArray[2])],
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
}

module.exports = ChartDrawer;
// Load the current Visualization API and the bar package.
google.charts.load('current', {'packages':['bar']});

/**
 * Class that handles drawing of charts using the Google Charts API.
 * TODO(Jamie): change data table population according to MATLAB output.
 */
class ChartDrawer {
    /**
     * Function used to create and populate a data table, instantiate the column chart,
     * pass in the data, and draw the chart in the selected div container.
     * @param {!Array} durationArray The array of duration data to be charted.
     */
    drawChart(durationArray) {
        // Callback that creates and populates a data table,
        // instantiates the column chart, passes in the data and
        // draws it.
        var data = google.visualization.arrayToDataTable([
          ['Stage', 'Duration (Minutes)'],
          ['N1', Number(durationArray[0])],
          ['N2', Number(durationArray[1])],
          ['N3', Number(durationArray[2])],
        ]);

        var options = {
            chart: {
                title: 'Sleep Stage Classification',
                subtitle: 'Duration (in Minutes)',
            },
            legend: {
                position: 'none',
            },
            vAxis: {
                minValue: 0,
                ticks: [0, 50, 100, 150, 200]
            }
        };

      var chart = new google.charts.Bar(document.getElementById('chart_div')); 
      
      chart.draw(data, google.charts.Bar.convertOptions(options));
   }
}

module.exports = ChartDrawer;

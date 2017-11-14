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
     * @param {!Array<Number>} durationArray The array of duration data to be charted.
     */
    drawChart(durationArray) {
        // Callback that creates and populates a data table,
        // instantiates the column chart, passes in the data and
        // draws it.
        let data = google.visualization.arrayToDataTable([
          ['Stage', 'Duration (Minutes)'],
          ['Wake', durationArray[0]],
          ['REM', durationArray[1]],
          ['Light Sleep', durationArray[2]],
          ['Deep Sleep', durationArray[3]],
        ]);

        let options = {
            'width': 300,
            'height': 225,
            chart: {
		title: 'Sleep Stage Classification',
                subtitle: 'Light Sleep vs. Deep Sleep (in Minutes)',
            },
            legend: {
                position: 'none',
            },
        };

      let chart = new google.charts.Bar(document.getElementById('chart_div')); 
      
      chart.draw(data, google.charts.Bar.convertOptions(options));
   }
}

module.exports = ChartDrawer;

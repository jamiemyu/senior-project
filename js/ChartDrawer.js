const moment = require("moment");
            
// Load the current Visualization API and the bar package.
google.charts.load('43', {packages: ['corechart']}); 

/**
 * Class that handles drawing of charts using the Google Charts API.
 */
class ChartDrawer {
    /**
     * Function used to create and populate a data table, instantiate the pie chart,
     * pass in the data, and draw the chart in the selected div container.
     * @param {!Array<Number>} durationArray The array of duration data to be charted.
     * @param {!String} div The div in which to draw the chart.
     */
    drawPieChart(durationArray, div) {
        // Callback that creates and populates a data table,
        // instantiates the column chart, passes in the data and
        // draws it.
        let data = new google.visualization.DataTable();
        data.addColumn('string', 'Stage');
        data.addColumn('number', 'Duration (Minutes)');
        
        data.addRow(['Awake', {v: durationArray[3], f: durationArray[3] + ' minutes'}]);
        data.addRow(['REM', {v: durationArray[2], f: durationArray[2] + ' minutes'}]);
        data.addRow(['Light', {v: durationArray[1], f: durationArray[1] + ' minutes'}]);
        data.addRow(['Deep', {v: durationArray[0], f: durationArray[0] + ' minutes'}]);

        let options = {
            backgroundColor: { fill:'transparent' },
            title: 'Sleep Composition',
            titleTextStyle: {
                color: '#1c313a',
                fontName: 'Source Sans Pro',
                fontSize: 16,
            },
            colors: ['#895352','#718792','#455a64','#1c313a'],
            legend: { position: 'left' },
            tooltip: { trigger: 'selection' },
        };

      const chart = new google.visualization.PieChart(document.getElementById(div)); 
      chart.draw(data, options);
    }
    
    /**
     * Function used to create and populate a data table, instantiate a segmented line
     * chart, and draw the chart into the selected div container.
     * @param {!Array<Number>} timelineModes The array of segment modes to be displayed
     * on the timeline.
     * @param {Number} n The length of each timeline segment.
     * @param {!String} div The div in which to draw the chart.
     */
    drawTimeline(timelineObjects, n, div) {
        let data = new google.visualization.DataTable();
        data.addColumn('number', 'Time of Day');
        data.addColumn('number', 'Sleep Stage');
        let i = 0;
        timelineObjects.forEach((object) => {
            const time = i * (n / 2);
            let timeFormatted = moment.utc(0).add(time, 'minutes').format('HH:mm');
            data.addRow([{v: time, f: timeFormatted}, object]);
            i++;
        });
        const numHours = Math.floor(timelineObjects.length / ((60 / n) * 2)) - 1;
        let hours = [];
        for (let i = 1; i <= numHours; i++) {
            hours[i - 1] = {v: 60 * i, f: 60 * i};
        }
        
        var options = {
            backgroundColor: { fill: 'transparent' },
            colors: ['#718792'],
            title: 'Estimated Sleep Timeline',
            titleTextStyle: {
                color: '#1c313a',
                fontName: 'Source Sans Pro',
                fontSize: 16,
            },
            hAxis: {
                title: 'Time (Minutes)',
                titleTextStyle: {
                    color: '#1c313a',
                    italic: false,
                    bold: true
                },
                ticks: hours,
            },
            vAxis: {
                title: 'Sleep Type',
                ticks: [{v:1, f:'Deep'},
                        {v:2, f:'Light'},
                        {v:3, f:'REM'},
                        {v:4, f:'Awake'}],
                titleTextStyle: {
                    color: '#1c313a',
                    italic: false,
                    bold: true
                },
            },
            isStacked: true,
            legend: { position: 'none' },
            'width': 900,
        };

        const chart = new google.visualization.SteppedAreaChart(document.getElementById(div));
        
        chart.draw(data, options);
    }
}

module.exports = ChartDrawer;

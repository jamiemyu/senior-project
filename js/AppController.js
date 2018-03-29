var path = require('path');
var DataParser = require( path.resolve( __dirname, "./js/DataParser.js" ) );

/**
 * Action that occurs when the analyze button is clicked. Handles modification of
 * HTML objects and using the client to make the request for data.
 */
function analyzeFile() {
    let filePath = document.getElementById("chooseFile").files[0].path;

    let extensionIndex = filePath.lastIndexOf(".");
    if (filePath.substring(extensionIndex+1, filePath.length) !== "txt") {
        alert("Invalid file format. Please upload text files only.");
        return;
    }
    
    document.getElementById('file-upload').innerHTML = '';
    document.getElementById('file-upload').innerHTML += '<object type="text/html"' + 
                                                    ' data="html/chart.html" ></object>';

    let MatlabClient = require('./js/MatlabClient.js');
    let ChartDrawer = require('./js/ChartDrawer.js');
    const client = new MatlabClient();
    client.requestData(filePath).then((output) => {
        document.body.style.backgroundColor = "white";
        document.getElementById('restart_div').style.visibility = "visible";
        document.getElementById('body_div').classList.remove('unloaded');
        document.getElementById('body_div').classList.add('loaded');

        // Remove loader bar once analysis is complete.
        document.getElementById('file-upload').remove();
        let parser = new DataParser();
        
        // Retrieve minute totals from output data.
        let sleepTotals = parser.getTotals(output);
        
        // Retrieve modes from output data.
        n = 30; // Find the mode of every (15 min = 2 * 15 30-s intervals)
        let timelineModes = parser.getModes(output, n);
        let timelineObjects = parser.getTimelineObjects(timelineModes);
 
        const drawer = new ChartDrawer();
        // Load the current Visualization API and the bar package.
        google.charts.load('43', {packages: ['corechart']}); 
        //google.charts.setOnLoadCallback(drawer.drawCharts);

        drawer.drawPieChart(sleepTotals, 'pie_chart_div');
        drawer.drawTimeline(timelineObjects, n, 'timeline_chart_div');
        
        // Retrieve stats from output data.
        const totalMinSleep = parser.getTotalMinSleep(sleepTotals);
        const totalMinAwake = parser.getTotalMinAwake(sleepTotals);
        
        let statsDiv = '<div id="sleep_stat_div"><div class="stats_title"><b>Time Asleep</b></div><h4>' + totalMinSleep + '</h4></div><div id="awake_stat_div"><div class="stats_title"><b>Time Awake</b></div><h4 style="color:#895352">' + totalMinAwake + '</h4></div>';
        
        document.getElementById('stats_div').innerHTML += statsDiv;
    });
}


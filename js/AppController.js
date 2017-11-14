/**
 * Action that occurs when the analyze button is clicked. Handles modification of
 * HTML objects and using the client to make the request for data.
 */
function analyzeFile() {
    let filepath = document.getElementById("chooseFile").files[0].path;
    document.getElementById('file-upload').remove();
    document.getElementById('submit-btn').remove();
    document.getElementById('chart_div').innerHTML += '<object type="text/html"' + 
                                                    ' data="html/chart.html" ></object>';

    let MatlabClient = require('./js/MatlabClient.js');
    let ChartDrawer = require('./js/ChartDrawer.js');
    const client = new MatlabClient();
    client.requestData(filepath).then((output) => {
        const drawer = new ChartDrawer();
        document.getElementById('header_div').classList.remove('unloaded'); 
        document.getElementById('header_div').classList.add('loaded'); 
        document.getElementById('chart_div').innerHTML = '';
        drawer.drawChart(output);
    })
}

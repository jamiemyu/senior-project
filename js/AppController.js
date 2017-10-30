LOADER_TEXT = '<h4>Analyzing ...</h4>'
LOADER_BAR = '<div class="progress-bar"><span class="bar">' + 
        '<span id="loader" class="progress"></span></span></div>';

/**
 * Action that occurs when the analyze button is clicked. Handles modification of
 * HTML objects and using the client to make the request for data.
 */
function analyzeFile() {
    let filepath = document.getElementById("chooseFile").files[0].path;
    document.getElementById('file-upload').remove();
    document.getElementById('submit-btn').remove();
    document.getElementById('chart_div').innerHTML += '<div class="loader_div">' + 
        LOADER_TEXT + LOADER_BAR + '</div>';

    let MatlabClient = require('./js/MatlabClient.js');
    let ChartDrawer = require('./js/ChartDrawer.js');
    const client = new MatlabClient();
    client.requestData(filepath).then((output) => {
        const drawer = new ChartDrawer();
        document.getElementById('header_div').classList.remove('unloaded'); 
        document.getElementById('header_div').classList.add('loaded'); 
        document.getElementById('chart_div').innerHTML = '';
        drawer.drawChart(output.split(" "));
    })
}

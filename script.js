function doSomething() {
    document.getElementById('submit-btn').remove();
    document.getElementById('chart_div').innerHTML += '<svg class="spinner" width="65px" height="65px" viewBox="0 0 66 66" xmlns="http://www.w3.org/2000/svg"><circle class="path" fill="none" stroke-width="6" stroke-linecap="round" cx="33" cy="33" r="30"></circle></svg>';
    
    let MatlabClient = require('./MatlabClient.js');
    let ChartDrawer = require('./js/ChartDrawer.js');
    const client = new MatlabClient();
    const drawer = new ChartDrawer();
    client.requestData().then((output) => {
        document.getElementById('chart_div').innerHTML = '';
        drawer.drawChart(output.split(" "));
    })
}
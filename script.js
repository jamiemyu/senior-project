function doSomething() {
    let MatlabClient = require('./MatlabClient.js');
    let ChartDrawer = require('./js/ChartDrawer.js');
    const client = new MatlabClient();
    const drawer = new ChartDrawer();
    client.requestData().then((output) => {
        document.getElementById('demo').append(output);
        drawer.drawChart(output.split(" "));
    })
}

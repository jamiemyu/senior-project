var Promise = require('bluebird');
const exec = require('child_process').exec;
const commandPath = '/Applications/MATLAB_R2016b.app/bin/matlab';
const options = '-nodisplay -r "run test(3); quit force"';

function promiseFromChildProcess(child) {
    return new Promise((resolve, reject) => {
        child.addListener("error", reject);
        child.addListener("exit", resolve);
    });
}

let child = exec(commandPath + ' ' + options);

promiseFromChildProcess(child).then((result) => {
    console.log('promise complete: ' + result);
}, (err) => {
    console.log('promise rejected: ' + err);
});

child.stdout.on('data', function (data) {
    if (!isNaN(data)) {
        saveData = data;
        console.log(data);
    }
});
child.stderr.on('data', function (data) {
    console.log('stderr: ' + data);
});
child.on('close', function (code) {
    console.log('closing code: ' + code);
});
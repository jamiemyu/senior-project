const DataParser = require('./DataParser.js');
const Promise = require('bluebird');
const exec = require("child_process").exec;


/**
 * This class represents a client used to interact with MATLAB. A MatlabClient
 * is able to execute a MATLAB script with passed in parameters, and receives an output.
 * For right now, the MatlabClient is proof of concept, and parses specifically for
 * the test output.
 * TODO(Jamie): Broaden this class to apply to all input types/output types.
 */
class MatlabClient {
    /**
     * Function used to call a MATLAB executable.
     * @param {!String} filePath The file path to give to MATLAB. 
     * @return {!Promise} A promise indicating success of MATLAB script execution.
     *     Contains the output data.
     */
    requestData(filePath) {
        return new Promise((resolve, reject) => {
            const path = '/Applications/MATLAB_R2016b.app/bin/matlab';
            // The name of the MATLAB script to execute.
            const matlabScript = ' classifierAlgorithm ' + "'" + filePath + "'; catch; end; quit force"
                                 + '"';
            const args = '-nodisplay -r "try;' + matlabScript;

            const child = exec(path + ' ' + args);
            let savedData = "";

            child.stdout.on('data', function (data) {
                console.log('output: ' + data);
                savedData += data;
            });

            child.stderr.on('data', function (data) {
                console.log('stderr: ' + data);
            });

            child.on('close', function (code) {
                console.log('closing code: ' + code);
            });

            this.promiseFromChildProcess(child).then((result) => {
                console.log('promise complete: ' + result);
                let parser = new DataParser();
                        resolve(parser.parseData(savedData));
            }, 
            (err) => {
                console.log('promise rejected: ' + err);
                reject(err);
            });
        });
        
    }


    /**
     * Function used to wrap a Promise around the child_process command.
     * Upon successful process completion, the promise will resolve.
     * {exec} child Spawns a shell then executes the command within that shell, buffering
     *     any generated output.
     */
    promiseFromChildProcess(child) {
        return new Promise((resolve, reject) => {
            child.addListener("error", reject);
            child.addListener("exit", resolve);
        });
    }
}


module.exports = MatlabClient;

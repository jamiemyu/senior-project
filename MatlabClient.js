const Promise = require('bluebird');
const exec = require("c"+"hild_process").exec;


/**
 * This class represents a client used to interact with MATLAB. A MatlabClient
 * is able to execute a MATLAB script with passed in parameters, and receives an output.
 * For right now, the MatlabClient is proof of concept, and parses specifically for
 * the test output.
 * TODO(Jamie): broaden this class to apply to all input types/output types.
 */
class MatlabClient {
    /**
     * Function used to call a MATLAB executable.
     * @param {!String} opt_filePath A filepath to send to MATLAB indicating where the
     *     file to analyze is stored.
     * @return {!Promise} A promise indicating success of MATLAB script execution.
     *     Contains the output data.
     */
    requestData(opt_filePath) {
        return new Promise((resolve, reject) => {
            const path = '/Applications/MATLAB_R2016b.app/bin/matlab';
            if (opt_filePath === undefined) opt_filePath = '';
            
            // The name of the MATLAB script to execute.
            const matlabScriptName = ' test(' + opt_filePath + ');'
            const args = '-nodisplay -r "run' + matlabScriptName + ' ' 
                         + 'quit force' + '"';
 
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

                // Find where the MATLAB output starts.
                let i = savedData.indexOf("only.");

                // Only store the MATLAB output substring, ignoring all other outputs
                resolve(savedData.substring(i+5, savedData.length - 1));
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
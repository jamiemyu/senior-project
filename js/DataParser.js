/**
 * Helper class used to parse data returned from a child_process.exec() call.
 * For different output types, the data should be handled appropriately according to
 *     what the ChartDrawer needs.
 */
class DataParser {
    /**
     * Function used to parse saved data for numbers output into the console by a 
     *     MATLAB script.
     * @param {!String} data The entire console output from the MATLAB function
     *     execution.
     * @return {!Array<Number>} numArr An array containing numbers from the MATLAB
     *     function execution.
     */
	parseData(data) {
        // Retrieve the index where the function starts outputting to the console.
	let i = data.indexOf("only.") + 7;

        let subStr = data.substring(i, data.length - 1);
        let strArr = subStr.split(' ');
        
        let numArr = [];
        strArr.forEach((numberStr) => {
            numArr.push(Number(numberStr));
        })
		return numArr;	
	}
}

module.exports = DataParser;

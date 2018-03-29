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
        let strArr = subStr.split("  ");
        let numArr = [];
        strArr.forEach((numberStr) => {
            numArr.push(Number(numberStr));
        })
		return numArr;	
	}
    
    /**
     * Function used to derive total minutes of sleep in each stage based on output
     *     numbers from a MATLAB script.
     * @param {!Array<Number>} data The array containing numbers from the MATLAB function
     *     execution.
     * @return {!Array<Number>} The array containing total number of minutes spent in
     *     each sleep stage.
     */
    getTotals(data) {
        let deepCounter = 0;
        let lightCounter = 0;
        let remCounter = 0;
        let wakeCounter = 0;
        for (let i = 0; i < data.length; i++) {
            let stage = data[i];
            /*
             * MAP:
             * Deep = 1
             * Light = 2
             * REM = 3
             * Wake = 4
             */ 
            switch(stage) {
                case 1:
                    deepCounter++;
                    break;
                case 2:
                    lightCounter++;
                    break;
                case 3:
                    remCounter++;
                    break;
                case 4:
                    wakeCounter++;
                    break;
            }
        }
        
        return [deepCounter, lightCounter, remCounter, wakeCounter];
    }

    /**
     * Function used to get the modes for every n elements from the array. If there is no
     *     singular mode, then the first number from the subsection is returned.
     * @param {!Array<Number>} data The array containing numbers from the MATLAB function
     *     execution.
     * @param {Number} n The size of the subsections from the array to find the mode
     *     from.
     * @return {!Array<Number>} intervalModes The array of modes found from subsections
     *     of size n from the array.
     */
    getModes(data, n) {
        let intervalModes = [];
        let startIndex = 0;
        let i = 0;
        while ((startIndex + (n - 1)) < data.length) {
            let interval = data.slice(startIndex, startIndex + n);
            startIndex = n * (i + 1);
            intervalModes[i++] = this.mode(interval);
        }
        return intervalModes;
    }
    
    /**
     * Helper function used to return the mode of an array.
     * @param {!Array<Number>} arr The array of numbers to find a mode from.
     * @return {Number} The mode of the array.
     */
    mode(arr) {
        return arr.sort((a,b) =>
              arr.filter(v => v===a).length
            - arr.filter(v => v===b).length
        ).pop();
    }
    
    /**
     * Function used to construct timeline objects from an array of modes. A timeline
     *     object is a key-value pair mapping the number to the name of the stage.
     * @param {!Array<Number>} timelineModes The array of modes to be represented on a
     *     timeline chart.
     * @return {!Array<Object>} timelineObjectsArr The array of objects to use in the
     *     chart drawing procedure.
     */
    getTimelineObjects(timelineModes) {
        let timelineObjectsArr = [];
        for (let i = 0; i < timelineModes.length; i++) {
            let mode = timelineModes[i];
            switch(mode) {
                case 1:
                    timelineObjectsArr.push({v: 1, f: 'Deep'});
                    break;
                case 2:
                    timelineObjectsArr.push({v: 2, f: 'Light'});
                    break;
                case 3:
                    timelineObjectsArr.push({v: 3, f: 'REM'});
                    break;
                case 4:
                    timelineObjectsArr.push({v: 4, f: 'Awake'});
                    break;
            }
        }
        return timelineObjectsArr;
    }
    
    /**
     * Helper function used to return the total minutes spent asleep (REM + Deep + Light).
     * @param {!Array<Number>} sleepTotals The array containing totals for all stages.
     * @return {Number} The total number of minutes spent asleep.
     */
    getTotalMinSleep(sleepTotals) {
        return sleepTotals[0] + sleepTotals[1] + sleepTotals[2];
    }
    
    /**
     * Helper function used to return the total minutes spent awake (Wake).
     * @param {!Array<Number>} sleepTotals The array containing totals for all stages.
     * @return {Number} The total number of minutes spent awake.
     */
    getTotalMinAwake(sleepTotals) {
        return sleepTotals[3];
    }
}

module.exports = DataParser;

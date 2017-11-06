const assert = require('assert');
const DataParser = require('../js/DataParser.js');

const testData = "only.  1 2 3 ";
const EXPECTED_DATA = [1, 2, 3];
console.log(testData);
describe('DataParser', () => {
    describe('parseData', () => {
        let parser = new DataParser();
        
        it('should return an array of numbers', () => {
	    parsedArr = parser.parseData(testData);
	    for (let i = 0; i < EXPECTED_DATA.length; i++) {
	      assert.equal(EXPECTED_DATA[i], parsedArr[i]);   
	    } 
        })
    })
});

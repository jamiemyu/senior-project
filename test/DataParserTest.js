const assert = require('assert');
const DataParser = require('../js/DataParser.js');

const testData = "only.  1  2  3 ";
const testSmallArr = [1, 2, 3, 3];
const testLargeArr = [1, 2, 3, 3, 1, 2, 2, 3, 1, 1, 1, 2];
const testSleepTotalsArr = [30, 60, 90, 120];
const EXPECTED_DATA = [1, 2, 3];

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

describe('DataParser', () => {
    describe('getTotals', () => {
        let parser = new DataParser();
        
        it('should return total number of each value in the array', () => {
	    let totals = parser.getTotals(testLargeArr);
        assert.equal(5, totals[0]);
        assert.equal(4, totals[1]);      
        assert.equal(3, totals[2]);
        })
    })
});

describe('DataParser', () => {
    describe('getModes', () => {
        let parser = new DataParser();
        
        it('should return modes of subsections of the array', () => {
	    let modes = parser.getModes(testLargeArr, 4);
	    assert.equal(3, modes[0]);
        assert.equal(2, modes[1]);      
        })
    })
});

describe('DataParser', () => {
    describe('mode', () => {
        let parser = new DataParser();
        
        it('should return mode of the array', () => {
	    mode = parser.mode(testSmallArr);
        assert.equal(3, mode);
        })
    })
});

describe('DataParser', () => {
    describe('getTimelineObjects', () => {
        let parser = new DataParser();
        
        it('should return an array of objects containing key-value pairs for the timeline', () => {
            let timelineObjects = parser.getTimelineObjects(testSmallArr);
            assert.equal(1, timelineObjects[0].v);
            assert.equal('Deep', timelineObjects[0].f);
            assert.equal(2, timelineObjects[1].v);
            assert.equal('Light', timelineObjects[1].f);
            assert.equal(3, timelineObjects[2].v);
            assert.equal('REM', timelineObjects[2].f);
        })
    })
});

describe('DataParser', () => {
    describe('getTotalMinSleep', () => {
        let parser = new DataParser();
        
        it('should return a number equal to the total time spent in deep, light and REM sleep combined', () => {
            let timeSleep = parser.getTotalMinSleep(testSleepTotalsArr);
            assert.equal(180, timeSleep);
        })
    })
});

describe('DataParser', () => {
    describe('getTotalMinAwake', () => {
        let parser = new DataParser();
        
        it('should return a number equal to the total time spent in wake state', () => {
            let timeAwake = parser.getTotalMinAwake(testSleepTotalsArr);
            assert.equal(120, timeAwake);
        })
    })
});



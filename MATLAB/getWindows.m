% Function that returns a cell array of data organized into windows.
% sampleArr is the array of samples being separated into windows
% windowDuration is the size of the window
function [tArr, windowArr] = getWindows(sampleArr, windowDuration, Fs)
numSamplesPerWindow = Fs * windowDuration;
numSamples = floor(length(sampleArr) / numSamplesPerWindow);

tArr = cell(1, numSamples);
windowArr = cell(1, numSamples);
for i = 1:numSamples
    startIndex = (i * numSamplesPerWindow) - numSamplesPerWindow + 1;
    endIndex = (i * numSamplesPerWindow);
    
    tArr{i} = [startIndex:endIndex];
    windowArr{i} = sampleArr(startIndex:endIndex);
end
end
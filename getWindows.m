% Function that returns a cell array of data organized into windows.
% sampleArr is the array of samples being separated into windows
% windowDuration is the size of the window
function windowArr = getWindows(sampleArr, windowDuration, Fs)
numSamplesPerWindow = Fs * windowDuration;
numSamples = length(sampleArr) / numSamplesPerWindow;

windowArr = cell(1, numSamples);
for i = 1:numSamples
    startIndex = (i * numSamplesPerWindow) - numSamplesPerWindow + 1;
    endIndex = (i * numSamplesPerWindow);
    windowArr{i} = sampleArr(startIndex:endIndex);
end


end

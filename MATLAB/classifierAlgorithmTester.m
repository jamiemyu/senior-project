%% Test Code for Classifier Algorithm

%% DEVELOPMENT NOTES
% mat2wfdb used to write MATLAB variable into WDFB record file

% theta = 4 - 7.9 Hz
% Lower Alpha = 7.9 - 10 Hz
% Upper Alpha = 10 - 13 Hz % edited
% Lower Beta = 13 - 17.9 Hz
% Upper Beta = 18 - 24.9 Hz

%% Classification Criteria

% Sleep stage 1/2 consist of Theta Waves (4-8Hz, amplitude 10)
% Sleep stage 3/4 consist of Delta Waves (0-4Hz, amplitude 20-100)
% REM sleep (R) demonstrate characteristics similar to waking sleep
% = a combination of alpha, beta, and desynchronous waves

% There is no real division between stages 3 and 4 except that,
% typically, stage 3 is considered delta sleep in which less than 50 
% percent of the waves are delta waves, and in stage 4 more than 50 percent
% of the waves are delta waves. 

%% Loading signal data from MIT-BIH slpdb

%{
% Read EEG signal from 18 records (3 = 3rd column).
[tm,rawData] = rdsamp('slpdb/slp14', 3);

% Read the annotation file. Each value represents a 30 second interval.
[~,~,~,~,~,comments] = rdann('slpdb/slp14', 'st');

% Get the sleep stages only.
classifierAnnotations = getSleepStages(comments);
%}

load('rawData_02a.mat');

%% PRE-PROCESSING

Fs = 250;  % samples (ticks)/second
dt = 1/Fs; % time resolution

% Bandpass filter the full data set
passBand = [0.6 35]; % Hz
filterHd = bandPassFilter(Fs, passBand);
filteredData = filter(filterHd, rawData);

% Specify length of window to segment the data
windowDuration = 30; % seconds
% Split the entire EEG signal recording into 30 second recordings.
[tArr, dataIntervals] = getWindows(filteredData, windowDuration, Fs);

%% STAGE 1

[lowFreqAverage1, highFreqAverage1, freqPowerRatio1] = getPowerRatio(1, classifierAnnotations, tArr, dataIntervals);

%% STAGE 2

[lowFreqAverage2, highFreqAverage2, freqPowerRatio2] = getPowerRatio(2, classifierAnnotations, tArr, dataIntervals);

%% STAGE 3

[lowFreqAverage3, highFreqAverage3, freqPowerRatio3] = getPowerRatio(3, classifierAnnotations, tArr, dataIntervals);

%% STAGE 4

[lowFreqAverage4, highFreqAverage4, freqPowerRatio4] = getPowerRatio(4, classifierAnnotations, tArr, dataIntervals);

%% STAGE WAKE

[lowFreqAverageW, highFreqAverageW, freqPowerRatioW] = getPowerRatio('W', classifierAnnotations, tArr, dataIntervals);

%% DISPLAY RESULTS
length1 = length(freqPowerRatio1);
length2 = length(freqPowerRatio2);
length3 = length(freqPowerRatio3);
length4 = length(freqPowerRatio4);
lengthW = length(freqPowerRatioW);

figure;
scatter(1:length1, freqPowerRatio1, 'k');
hold on
scatter((length1 + 1):(length1 + length2), freqPowerRatio2, 'r');
hold on
scatter((length1 + length2 + 1):(length1 + length2 + length3), freqPowerRatio3, 'k');
hold on
scatter((length1 + length2 + length3 + 1):(length1 + length2 + length3 + length4), freqPowerRatio4, 'b');
hold on
scatter((length1 + length2 + length3 + length4 + 1):(length1 + length2 + length3 + length4 + lengthW), freqPowerRatioW, 'k');


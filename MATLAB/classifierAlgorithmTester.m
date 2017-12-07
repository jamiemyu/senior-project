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

load('rawData_01a.mat');

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

%% REM

[lowFreqAverageR, highFreqAverageR, freqPowerRatioR] = getPowerRatio('R', classifierAnnotations, tArr, dataIntervals);

%% DISPLAY RESULTS

length1 = length(freqPowerRatio1);
length2 = length(freqPowerRatio2);
length12 = length1 + length2;
length3 = length(freqPowerRatio3);
length4 = length(freqPowerRatio4);
length34 = length3 + length4;
lengthW = length(freqPowerRatioW);
lengthR = length(freqPowerRatioR);
totalLength = length12 + length34 + lengthW + lengthR;

figure;
scatter(1:length12, [freqPowerRatio1 freqPowerRatio2], 'k');
hold on
scatter((length12 + 1):(length12 + length34), [freqPowerRatio3 freqPowerRatio4], 'r');
hold on
scatter((length12 + length34 + 1):(length12 + length34 + lengthW), freqPowerRatioW, 'b');
hold on
scatter((length12 + length34 + lengthW + 1):(length12 + length34 + lengthW + lengthR), freqPowerRatioR, 'm');

legend('Light Sleep', 'Deep Sleep', 'Wake', 'REM');
grid on;

%% OUTPUT TEST RESULTS

% Initialize sampling frequency 
Fs = 250;
dt = 1/Fs;
% Initialize variables used in for loop
% Stores average power using specified cutoff values
% Stores average power in low freq range
lowFreqAverage = zeros(1,length(classifierAnnotations));
lowFreqAverageRange = [1 4];
% Stores average power in high freq range
highFreqAverage = zeros(1,length(classifierAnnotations));
highFreqAverageRange = [5 12];
lightSleepCorrect = 0;
deepSleepCorrect = 0;
wakeCorrect = 0;
remCorrect = 0;

for i = 1:length(classifierAnnotations)
    % Save correct classification
    correctStage = classifierAnnotations{i};
    % Load time vector according to indexed window
    t = tArr{i};
    % Total timespan of recorded data
    T0 = length(t)/Fs;
    % Frequency resolution - determined by T0
    dF = 1/T0;
    % Freq data of DFT result
    freq = (-Fs/2:dF:Fs/2 - dF)';
    % Load EEG data in time domain according to indexed window
    sleepData = dataIntervals{i};
    % Use Fast Fourier Transform to transform data to frequency domain
    dataInFreqDomain = abs(fftshift(fft(sleepData*dt)));
    
    % Calculate average power at low frequency range
    lowFreqAverage = (mean(dataInFreqDomain(find(freq == lowFreqAverageRange(1)):find(freq == lowFreqAverageRange(2)))))^2;
    % Calculate average power at high frequency range
    highFreqAverage = (mean(dataInFreqDomain(find(freq == highFreqAverageRange(1)):find(freq == highFreqAverageRange(2)))))^2;
    
    % Classify based on cutoff values determined by testing 
    if (correctStage ~= 'MT');
        if ((lowFreqAverage / highFreqAverage) <= 8.5 && (lowFreqAverage / highFreqAverage) >= 5.6)
            if (correctStage == 1 || correctStage == 2)
                lightSleepCorrect = lightSleepCorrect + 1;
            end
        elseif ((lowFreqAverage / highFreqAverage) > 8.5)
            if (correctStage == 3 || correctStage == 4)
                deepSleepCorrect = deepSleepCorrect + 1;
            end
        elseif ((lowFreqAverage / highFreqAverage) < 5.6 && (lowFreqAverage / highFreqAverage) >= 2.2)
            if (correctStage == 'W')
                wakeCorrect = wakeCorrect + 1;
            end
        else
            if (correctStage == 'R')
                remCorrect = remCorrect + 1;
            end
        end
    end
    
end

percentLightSleepCorrect = (lightSleepCorrect / (length1 + length2)) * 100;
percentDeepSleepCorrect = (deepSleepCorrect / (length3 + length4)) * 100;
percentWakeCorrect = (wakeCorrect / lengthW) * 100;
percentRemCorrect = (remCorrect / lengthR) * 100;

fprintf('Light: %f, Deep: %f, Wake: %f, Rem: %f\n', percentLightSleepCorrect, percentDeepSleepCorrect, percentWakeCorrect, percentRemCorrect);



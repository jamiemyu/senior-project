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

% Read EEG signal (3 = 3rd column).
[tm,rawData] = rdsamp('slpdb/slp02a', 3);

% Read the annotation file. Each value represents a 30 second interval.
[~,~,~,~,~,comments] = rdann('slpdb/slp02a', 'st');

% Get the sleep stages only.
classifierAnnotations = getSleepStages(comments);

%% PRE-PROCESSING

Fs = 250;  % samples (ticks)/second
dt = 1/Fs; % time resolution

filterHd = bandPassFilter(Fs);
filteredData = filter(filterHd, rawData);

% Specify length of window to segment the data
windowDuration = 30; % seconds
% Split the entire EEG signal recording into 30 second recordings.
[tArr, dataIntervals] = getWindows(filteredData, windowDuration, Fs);


%% Testing Stages 1 and 3

%{
In this section, I wrote code to loop through each of the windows that have
been classified as stages 1 and 3 and analyzed the power in different
frequency ranges. These tests will be used to analyze the efficacy of
classifying sleep states based on the average value of the signal in  the
frequency domain within specified frequency ranges (both low and high).
%}

% STAGE 1

% Find all windows that are classified as stage 1 sleep
sleepStage1Index = find([classifierAnnotations{:}] == 1);
% Initialize variables used in for loop
% Stores average power using specified cutoff values
totalAverage1 = zeros(1,length(sleepStage1Index));
totalAverageRange1 = [0.5 40];
% Stores average power from 0.5 - 3 Hz
lowFreqAverage1 = zeros(1,length(sleepStage1Index));
lowFreqAverageRange1 = [0.5 3];
% Stores average power from 5 - 15 Hz
highFreqAverage1 = zeros(1,length(sleepStage1Index));
highFreqAverageRange1 = [5 15];
% Loop through all sleep stage 1 data
for i = 1:length(sleepStage1Index);
    % Load time vector according to indexed window
    tSleepStage1 = tArr{sleepStage1Index(i)};
    % Total timespan of recorded data
    T0 = length(tSleepStage1)/Fs;
    % Frequency resolution - determined by T0
    dF = 1/T0;
    % Time vector of sampled data
    time = (0:dt:T0 - dt)';
    % Freq data of DFT result
    freq = (-Fs/2:dF:Fs/2 - dF)';
    % Load EEG data in time domain according to indexed window
    sleepDataStage1 = dataIntervals{sleepStage1Index(i)};
    % Use Fast Fourier Transform to transform data to frequency domain
    DataInFreqDomain1 = abs(fftshift(fft(sleepDataStage1*dt)));
    % Save average power of signal in 3 different frequency ranges
    totalAverage1(i) = mean(DataInFreqDomain1(find(freq == totalAverageRange1(1)):find(freq == totalAverageRange1(2))));
    lowFreqAverage1(i) = mean(DataInFreqDomain1(find(freq == lowFreqAverageRange1(1)):find(freq == lowFreqAverageRange1(2))));
    highFreqAverage1(i) = mean(DataInFreqDomain1(find(freq == highFreqAverageRange1(1)):find(freq == highFreqAverageRange1(2))));
    
    
end

lowFreqPowerRatio1 = lowFreqAverage1 ./ totalAverage1;
highFreqPowerRatio1 = highFreqAverage1 ./ totalAverage1;


% STAGE 3

% Find all windows that are classified as stage 3 sleep
sleepStage3Index = find([classifierAnnotations{:}] == 3);
% Initialize variables used in for loop
% Stores average power using specified cutoff values
totalAverage3 = zeros(1,length(sleepStage3Index));
totalAverageRange3 = [0.5 40];
% Stores average power from 0.5 - 3 Hz
lowFreqAverage3 = zeros(1,length(sleepStage3Index));
lowFreqAverageRange3 = [0.5 3];
% Stores average power from 5 - 15 Hz
highFreqAverage3 = zeros(1,length(sleepStage3Index));
highFreqAverageRange3 = [5 15];
% Loop through all sleep stage 1 data
for i = 1:length(sleepStage3Index);
    % Load time vector according to indexed window
    tSleepStage3 = tArr{sleepStage3Index(i)};
    % Total timespan of recorded data
    T0 = length(tSleepStage3)/Fs;
    % Frequency resolution - determined by T0
    dF = 1/T0;
    % Time vector of sampled data
    time = (0:dt:T0 - dt)';
    % Freq data of DFT result
    freq = (-Fs/2:dF:Fs/2 - dF)';
    % Load EEG data in time domain according to indexed window
    sleepDataStage3 = dataIntervals{sleepStage3Index(i)};
    % Use Fast Fourier Transform to transform data to frequency domain
    DataInFreqDomain3 = abs(fftshift(fft(sleepDataStage3*dt)));
    % Save average power of signal in 3 different frequency ranges
    totalAverage3(i) = mean(DataInFreqDomain3(find(freq == totalAverageRange(1)):find(freq == totalAverageRange(2))));
    lowFreqAverage3(i) = mean(DataInFreqDomain3(find(freq == lowFreqAverageRange(1)):find(freq == lowFreqAverageRange(2))));
    highFreqAverage3(i) = mean(DataInFreqDomain3(find(freq == highFreqAverageRange(1)):find(freq == highFreqAverageRange(2))));
    
    
end

lowFreqPowerRatio3 = lowFreqAverage3 ./ totalAverage3;
highFreqPowerRatio3 = highFreqAverage3 ./ totalAverage3;



%% Compare sleep stages through plotting.
fig1 = figure(1);
subplot(5,1,1)
plot(tSleepStage3, sleepStage3InAlpha);
xlabel('Sample (250 samples/sec)')
ylabel('EEG Signal')
xlim([tSleepStage3(1) tSleepStage3(end)]);
set(gcf, 'Position', [0, 210, 1440, 800])
title('Theta Wave Filtered EEG Signal, Time Domain');
grid on

subplot(5,1,2)
plot(f, DFT2Delta);
xlabel('Frequency (Hz)');
xlim([-20 20]);
title('Delta Wave Filtered EEG Signal, Frequency Domain');
grid on

subplot(5,1,3)
plot(f, DFT2Theta);
xlabel('Frequency (Hz)');
xlim([-20 20]);
title('Theta Wave Filtered EEG Signal, Frequency Domain');
grid on

subplot(5,1,4)
plot(f, DFT2Alpha);
xlabel('Frequency (Hz)');
xlim([-20 20]);
title('Alpha Wave Filtered EEG Signal, Frequency Domain');
grid on

subplot(5,1,5)
plot(f, DFT2Beta);
xlabel('Frequency (Hz)');
xlim([-20 20]);
title('Beta Wave Filtered EEG Signal, Frequency Domain');
grid on

saveas(fig1, 'bandpass_filter.jpg');

%% CLASSIFICATION

xIndex2 = find(DFT2Beta == max(DFT2Beta), 1, 'last');
maxXValue2 = f(xIndex2);

maxValues = [maxXValue2];

classifiedStageArr = zeros(1, length(maxValues));
for i = 1:length(maxValues)
    if (maxValues(i) >= 13) % Beta
        classifiedStageArr(i) = 1;
    elseif (maxValues(i) >= 4 && maxValues(i) <= 8) % Theta
        classifiedStageArr(i) = 2;
    elseif (maxValues(i) >= 0.5 && maxValues(i) < 4) % Delta
        classifiedStageArr(i) = 3;
    end
end
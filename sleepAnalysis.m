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

highPassCutoff = 0.5; % Hz
lowPassCutoff  = 50;  % Hz

filterHd = bandPassFilter(Fs);
filteredData = filter(filterHd, rawData);

% Specify length of window to segment the data
windowDuration = 30; % seconds
% Split the entire EEG signal recording into 30 second recordings.
[tArr, dataIntervals] = getWindows(filteredData, windowDuration, Fs);

% Find index where sleep stage is classified as 3
sleepStage3Index = find([classifierAnnotations{:}] == 3);
tSleepStage3 = tArr{sleepStage3Index(1)}; % Associated time values
dt = 1/Fs; % time resolution
T0 = length(tSleepStage3)/Fs;
dF = 1/T0;
time = (0:dt:T0 - dt)';
freq = (-Fs/2:dF:Fs/2 - dF)';


% TESTING DFT FOR STAGE 1 AND 3
sleepStage3 = dataIntervals{sleepStage3Index(1)};
sampleDFT3 = abs(fftshift(fft(sleepStage3*dt)));
totalAverage = mean(sampleDFT3(find(freq == 0.5):find(freq == 40)));
lowFreqAverage = mean(sampleDFT3(find(freq == 0.5):find(freq == 4)));
highFreqAverage = mean(sampleDFT3(find(freq == 5):find(freq == 15)));
figure;
plot(freq,sampleDFT)
xlim([0 55])
title('Stage 3')

sleepStage1Index = find([classifierAnnotations{:}] == 1);
tSleepStage1 = tArr{sleepStage1Index(5)}; % Associated time values
sleepStage1 = dataIntervals{sleepStage1Index(5)};
sampleDFT1 = abs(fftshift(fft(sleepStage1*dt)));
totalAverage1 = mean(sampleDFT1(find(freq == 0.5):find(freq == 40)));
lowFreqAverage1 = mean(sampleDFT1(find(freq == 0.5):find(freq == 4)));
highFreqAverage1 = mean(sampleDFT1(find(freq == 5):find(freq == 15)));
figure;
plot(freq,sampleDFT1)
xlim([0 55])
title('Stage 1')

%{
for i = 1:length(dataIntervals);
    
    
end
%}

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
%% DEVELOPMENT NOTES
% mat2wfdb used to write MATLAB variable into WDFB record file

% TODO: write helper function to parse comments for numbers 1-4, and 'R'.
%% Loading signal data from MIT-BIH slpdb

% Read EEG signal (3 = 3rd column).
[tm,sleepStages] = rdsamp('slpdb/slp02a', 3);

% Read the annotation file. Each value represents a 30 second interval.
[~,~,~,~,~,comments] = rdann('slpdb/slp02a', 'st');

% Get the sleep stages only.
classifierArr = getSleepStages(comments);

Fs = 250; % samples (ticks)/second
windowDuration = 30; % seconds

% Split the entire EEG signal recording into 30 second recordings.
[tArr, windowedArr] = getWindows(sleepStages, 30, Fs);

% Test plotting an interval classified as Sleep Stage 1
% We can find a demo sleep stage 1 interval by searching the classifierArr
% For an index labeled as "1".
sleepStage1Index = find([classifierArr{:}] == 1);
sleepStage1 = windowedArr{sleepStage1Index(1)};
tSleepStage1 = tArr{sleepStage1Index(1)};

% Test plotting an interval classified as Sleep Stage 2.
sleepStage2Index = find([classifierArr{:}] == 2);
sleepStage2 = windowedArr{sleepStage2Index(1)};
tSleepStage2 = tArr{sleepStage2Index(1)}; % Associated time values

% Test plotting an interval classified as Sleep Stage 3.
sleepStage3Index = find([classifierArr{:}] == 3);
sleepStage3 = windowedArr{sleepStage3Index(1)};
tSleepStage3 = tArr{sleepStage3Index(1)}; % Associated time values

% Test plotting an interval classified as Sleep Stage 4.
sleepStage4Index = find([classifierArr{:}] == 4);
sleepStage4 = windowedArr{sleepStage4Index(1)};
tSleepStage4 = tArr{sleepStage4Index(1)}; % Associated time values


%% Test plots (Time Domain <-> Frequency Domain)

% Calculate specifications for frequency domain.
dF = Fs/N;       
f = -Fs/2:dF:Fs/2-dF;

% Design a bandpass filter to limit to 3-40Hz.
d = fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2',1,3,40,45,40,1,40,Fs);
Hd = design(d,'cheby2');

sleepStage1 = filter(Hd, sleepStage1);
DFT1 = abs(fftshift(fft(sleepStage1)));
sleepStage2 = filter(Hd, sleepStage2);
DFT2 = abs(fftshift(fft(sleepStage2)));
sleepStage3 = filter(Hd, sleepStage3);
DFT3 = abs(fftshift(fft(sleepStage3)));
sleepStage4 = filter(Hd, sleepStage4);
DFT4 = abs(fftshift(fft(sleepStage4)));

%% Find frequencies with maximum amplitude
xIndex1 = find(DFT1 == max(DFT1), 1, 'last');
maxXValue1 = freq(xIndex1);

xIndex2 = find(DFT2 == max(DFT2), 1, 'last');
maxXValue2 = freq(xIndex2);

xIndex3 = find(DFT3 == max(DFT3), 1, 'last');
maxXValue3 = freq(xIndex3);

xIndex4 = find(DFT4 == max(DFT4), 1, 'last');
maxXValue4 = freq(xIndex4);

maxValues = [maxXValue1, maxXValue2, maxXValue3, maxXValue4];

classifiedStageArr = zeros(1, length(maxValues));
for i = 1:length(maxValues)
    if (maxValues(i) >= 13) % Beta
        classifiedStageArr(i) = 1;
    elseif (maxValues(i) >= 4 && maxValues(i) <= 7) % Theta
        classifiedStageArr(i) = 2;
    elseif (maxValues(i) >= 0.5 && maxValues(i) < 4) % Delta
        classifiedStageArr(i) = 3;
    end
end


%% Compare sleep stages through plotting.
fig1 = figure(1);
subplot(2,4,1)
plot(tSleepStage1, sleepStage1);
xlabel('Sample (250 samples/sec)')
ylabel('EEG Signal')
xlim([tSleepStage1(1) tSleepStage1(end)]);
set(gcf, 'Position', [0, 210, 1400, 600])
title('Sleep Stage 1, Time Domain');
grid on

subplot(2,4,2)
plot(tSleepStage2, sleepStage2);
xlabel('Sample (250 samples/sec)')
ylabel('EEG Signal')
xlim([tSleepStage2(1) tSleepStage2(end)]);
set(gcf, 'Position', [0, 210, 1440, 800])
title('Sleep Stage 2, Time Domain');
grid on

subplot(2,4,3)
plot(tSleepStage3, sleepStage3);
xlabel('Sample (250 samples/sec)')
ylabel('EEG Signal')
xlim([tSleepStage3(1) tSleepStage3(end)]);
set(gcf, 'Position', [0, 210, 1440, 800])
title('Sleep Stage 3, Time Domain');
grid on

subplot(2,4,4)
plot(tSleepStage4, sleepStage4);
xlabel('Sample (250 samples/sec)')
ylabel('EEG Signal')
xlim([tSleepStage4(1) tSleepStage4(end)]);
set(gcf, 'Position', [0, 210, 1440, 800])
title('Sleep Stage 4, Time Domain');
grid on

subplot(2,4,5)
plot(f, DFT1);
xlabel('Frequency (Hz)');
xlim([-20 20]);
title('Sleep Stage 1, Frequency Domain');
grid on

subplot(2,4,6)
plot(f, DFT2);
xlabel('Frequency (Hz)');
xlim([-20 20]);
title('Sleep Stage 2, Frequency Domain');
grid on

subplot(2,4,7)
plot(f, DFT3);
xlabel('Frequency (Hz)');
xlim([-20 20]);
title('Sleep Stage 3, Frequency Domain');
grid on

subplot(2,4,8)
plot(f, DFT4);
xlabel('Frequency (Hz)');
xlim([-20 20]);
title('Sleep Stage 4, Frequency Domain');
grid on
saveas(fig1, 'sleepStages1-4_comparison.jpg');
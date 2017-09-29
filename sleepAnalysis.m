%% DEVELOPMENT NOTES
% mat2wfdb used to write MATLAB variable into WDFB record file

% TODO: write helper function to parse comments for numbers 1-4, and 'R'.
%% Loading signal data from MIT-BIH slpdb

% Read EEG signal (3 = 3rd column).
[tm,sleepStages] = rdsamp('slpdb/slp01a', 3);

% Read the annotation file. Each value represents a 30 second interval.
[ann,anntype,subtype,chan,num,comments] = rdann('slpdb/slp01a', 'st');

% Get the sleep stages only.
classifierArr = getSleepStages(comments);

Fs = 250; % samples (ticks)/second
windowDuration = 30; % seconds

% Split the entire EEG signal recording into 30 second recordings.
windowedArr = getWindows(sleepStages, 30, Fs);
%% Plotting the data
dt = 1/Fs;
t = 0:dt:30;
df = 1/30;
freq = -Fs/2:df:Fs/2;

sleepStage4 = sleepStages(1:7500);

fig1 = figure(1);
subplot(2,1,1)
plot(tm4, sleepStage4); % Reduce sampling to 100 ticks/sec
xlabel('Time (sec)')
grid on
subplot(2,1,2)
plot(freq(1:end-1), DFT4)
xlim([-10 10])
grid on

fig2 = figure(2);
subplot(2,1,1)
plot(tm1, sleepStage1); % Reduce sampling to 100 ticks/sec
xlabel('Time (sec)')
grid on
subplot(2,1,2)
plot(freq, DFT1)
xlim([-25 25])
grid on

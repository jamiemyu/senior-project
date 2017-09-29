%% DEVELOPMENT NOTES
% mat2wfdb used to write MATLAB variable into WDFB record file

% Known Variables
Fs = 250; % samples (ticks)/second

%% Loading signal data from MIT-BIH slpdb

% Read EEG signal (3 = 3rd column). NOTE: this takes time b/c 250 ticks/sec
% For now, read 7500 samples (first 30 seconds)
[tm,sleepStages] = rdsamp('slpdb/slp01a', 3);

%% Read annotation

% ann: Nx1 integer vector of the annotation locations in samples
%        with respect to the beginning of the record. 
%        To convert this vector to a string of time stamps see WFDBTIME.
% anntype: Nx1 character vector describing the annotation types.
%        For a list of standard annotation codes used by PhyioNet, see:
%              http://www.physionet.org/physiobank/annotations.shtml
% subtype: Nx1 integer vector describing annotation subtype.
% chan: chan
% num: Nx1 integer vector describing annotation NUM.
% comments: Nx1 cell of strings describing annotation comments.

% Read the annotation file. Each value represents a 30 second interval
[ann,anntype,subtype,chan,num,comments] = rdann('slpdb/slp01a', 'st');

% TODO: write helper function to parse comments to get numbers 1-4, and 'R'

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

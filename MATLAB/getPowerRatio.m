% Function to calculate the frequency power ratio of a given stage

function freqPowerRatio = getPowerRatio(stage, classifierAnnotations, tArr, dataIntervals)

% Initialize sampling frequency 
Fs = 250;
dt = 1/Fs;
% Find all windows that are classified as the input sleep stage
sleepStageIndex = find([classifierAnnotations{:}] == stage);
% Initialize variables used in for loop
% Stores average power using specified cutoff values
totalAverage = zeros(1, length(sleepStageIndex));
totalAverageRange = [0.5 40];
% Stores average power from 1 - 3.5 Hz
lowFreqAverage = zeros(1,length(sleepStageIndex));
lowFreqAverageRange = [1 3.5];
% Stores average power from 5 - 15 Hz
highFreqAverage = zeros(1,length(sleepStageIndex));
highFreqAverageRange = [5 15];

% Loop through all data in given sleep stage
for i = 1:length(sleepStageIndex)
    if (sleepStageIndex(i) <= length(sleepStageIndex))
        % Load time vector according to indexed window
        tSleepStage = tArr{sleepStageIndex(i)};
        % Total timespan of recorded data
        T0 = length(tSleepStage)/Fs;
        % Frequency resolution - determined by T0
        dF = 1/T0;
        % Time vector of sampled data
        time = (0:dt:T0 - dt)';
        % Freq data of DFT result
        freq = (-Fs/2:dF:Fs/2 - dF)';
        % Load EEG data in time domain according to indexed window
        sleepDataStage = dataIntervals{sleepStageIndex(i)};
        % Use Fast Fourier Transform to transform data to frequency domain
        DataInFreqDomain = abs(fftshift(fft(sleepDataStage*dt)));
        % Save average power of signal in 3 different frequency ranges
        totalAverage(i) = mean(DataInFreqDomain(find(freq == totalAverageRange(1)):find(freq == totalAverageRange(2))));
        lowFreqAverage(i) = mean(DataInFreqDomain(find(freq == lowFreqAverageRange(1)):find(freq == lowFreqAverageRange(2))));
        highFreqAverage(i) = mean(DataInFreqDomain(find(freq == highFreqAverageRange(1)):find(freq == highFreqAverageRange(2))));
    end
end

freqPowerRatio = (lowFreqAverage ./ highFreqAverage) .^ 2;

end
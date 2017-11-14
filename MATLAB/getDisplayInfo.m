function output = getDisplayInfo(classifierArr)

% Calculate duration in minutes (# windows * 30s/window * 1 min/60sec).
lightSleepDur = classifierArr(1) / 2;
deepSleepDur = classifierArr(2) / 2; 

totalSleepDur = lightSleepDur + deepSleepDur;
totalSleepDurHours = totalSleepDur / 60;
totalSleepDurMins = mod(totalSleepDur, 60);

% Concatenate the output, which is a string representation of the light
% and deep sleep values.
output = strcat({num2str(lightSleepDur)}, {' '}, ...
                {num2str(deepSleepDur)}, {' '}, ...
                {num2str(totalSleepDurHours)}, {' '}, ...
                {num2str(totalSleepDurMins)});
            
% Display the output so that it is recorded in the console.
output = output{1};
end
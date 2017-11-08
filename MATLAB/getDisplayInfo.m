function output = getDisplayInfo(classifierArr)

% Calculate duration in minutes (# windows * 30s/window * 1 min/60sec).
lightSleepDur = classifierArr(1) / 2;
deepSleepDur = classifierArr(2) / 2; 

% Concatenate the output, which is a string representation of the light
% and deep sleep values.
output = strcat({num2str(lightSleepDur)}, {' '}, ...
                {num2str(deepSleepDur)});
            
% Display the output so that it is recorded in the console.
output = output{1};
end
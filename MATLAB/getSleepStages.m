function classifierArr = getSleepStages(comments)

classifierArr = cell(1, length(comments));
for i = 1:length(comments)
    sleepStage = comments{i}(1);
    if (sleepStage == 'R')
        classifierArr{i} = 'R';
    elseif (sleepStage == 'W')
        classifierArr{i} = 'W';
    elseif (sleepStage == 'M')
        classifierArr{i} = 'MT';
    else
        classifierArr{i} = str2double(comments{i}(1));
    end
end
end
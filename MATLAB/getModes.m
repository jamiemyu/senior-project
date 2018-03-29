function intervalModes = getModes(data, n)
% Return the mode for every n samples.

intervalModes = zeros(1, floor(length(data) / n));

startIndex = 1;
for i = 1:length(intervalModes)
    interval = data(startIndex:startIndex + (n-1));
    startIndex = n * i;
    intervalModes(i) = mode(interval);
end

end
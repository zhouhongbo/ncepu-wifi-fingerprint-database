function [result] = findSamplesInRage(pointIds, minVal, maxVal)
% findSamplesInRage  From the list of ids pointIds, return the ids the 
% samples that correspond to the interval [minVal, maxVal] of each point.
%
%   See also loadPointIds,findSample.
    digits = rem(pointIds, 10^2);
    result = (digits >= minVal)&((digits <= maxVal));
end
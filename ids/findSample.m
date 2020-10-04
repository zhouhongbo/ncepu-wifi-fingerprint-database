function [result] = findSample(pointIds, sampleNumber)
% findSample  From the list of ids pointIds, return the id of each sample
% corresponding to sampleNumber of each point.
%
%   See also loadPointIds,findSamplesInRage.
    result = findSamplesInRage(pointIds, sampleNumber, sampleNumber);
end
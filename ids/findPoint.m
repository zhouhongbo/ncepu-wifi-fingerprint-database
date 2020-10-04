function [result] = findPoint(pointIds, pointNumber)
% findPoint  From the list of ids pointIds, return the ids of all samples
% of points with number pointNumber.
%
%   See also loadPointIds,findPointsInRage.
    result = findPointsInRage(pointIds, pointNumber, pointNumber);
end
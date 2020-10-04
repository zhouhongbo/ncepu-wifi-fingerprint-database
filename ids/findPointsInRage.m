function [result] = findPointsInRage(pointIds, minVal, maxVal)
% findPointsInRage  From the list of ids pointIds, return the ids of all
% samples of points whose numbers lie in the [minVal, maxVal] interval.
%
%   See also loadPointIds,findPoint.
    digits = rem(floor(pointIds./10^2), 10^3);
    result = (digits >= minVal)&((digits <= maxVal));
end
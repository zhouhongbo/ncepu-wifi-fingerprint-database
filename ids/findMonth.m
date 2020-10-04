function [result] = findMonth(pointIds, month)
% findMonth  From the list of ids pointIds, return the ids of all samples
% that belong to datasets from the specified month.
%
%   See also loadPointIds.

    digits = rem(floor(pointIds./10^8), 10^2);
    result = digits == month;
end
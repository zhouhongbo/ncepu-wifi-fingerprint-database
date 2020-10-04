function [result] = findCampNumber(pointIds, campNumber)
% findCampNumber  From the list of ids pointIds, return the ids of all
% samples that belong to datasets with the specified campaign number.
%
% See also loadPointIds.

    digits = rem(floor(pointIds./10^6), 10^2);
    result = digits == campNumber;
end
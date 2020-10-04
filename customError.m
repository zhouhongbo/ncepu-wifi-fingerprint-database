function [e,fsr] = customError(estimationPos, actualPos, floorPenalty)
%customError  Estimate locations for the query elements, finding the k nearest neighbors in the rss space.
%   estimationPos and actualPos: estimated and actual positions, respectively
%   positions: Locations associated to training rss values
%   floorPenalty: Floor difference penalty value. A default value (5) is assumed if not supplied. For example, if for a pair of locations, the 2D distance is 3 m, the floor difference is 2, and 3 is supplied as floorPenalty, the final distance is 8.
%
%   See also probEstimation, stgKNNEstimation.

    e = sqrt(sum((estimationPos(:,[1,2])-actualPos(:,[1,2])).^2, 2));
    if (~exist('floorPenalty', 'var'))
        floorPenalty = 5;
    end
    fDiff = abs(estimationPos(:,3) - actualPos(:,3));
    fsr = sum(fDiff==0)/size(actualPos,1);
    penalty = fDiff*floorPenalty;
    e = e + penalty;
end
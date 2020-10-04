% Copyright © 2017 Universitat Jaume I (UJI)
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of
% this software and associated documentation files (the “Software”), to deal in
% the Software without restriction, including without limitation the rights to
% use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
% of the Software, and to permit persons to whom the Software is furnished to do
% so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

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
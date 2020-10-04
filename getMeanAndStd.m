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

function [M, S, pos] = getMeanAndStd(samples, locations, ids)
%GETMEANANDSTD  Get the mean and standard deviations values
%   [M, S, pos] = GETMEANANDSTD(samples, locations) get the mean M,
%   standard deviation S computed from rss values samples associated to
%   positions pos. pos are determined as the unique values of locations.
%
%   [M, S, pos] = GETMEANANDSTD(samples, locations, ids) similar to the
%   previous signature, but pos are determined using ids, which specifies
%   the correspondence between points and rows in samples and locations.

    if (exist('ids','var'))
        [uids, ~, ic] = unique(ids, 'rows');
    else
        [uids, ~, ic] = unique(locations, 'rows');
    end
    nCols = size(samples,2);
    nRows = size(uids,1);
    M = zeros(nRows,nCols);
    S = zeros(nRows,nCols);
    
    pos = zeros(nRows,3);
    
    for i = (1:nRows)
        indexes = ic == i;
        values = samples(indexes, :);
        M(i,:) = mean(values, 'omitnan');
        S(i,:) = std(values, 'omitnan');
        pos(i,:) = mean(locations(indexes,:));
    end
end
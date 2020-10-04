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
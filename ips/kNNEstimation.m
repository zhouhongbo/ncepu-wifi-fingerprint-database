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

function [prediction] = kNNEstimation(samples, query, positions, k)
% kNNEstimation  Estimate locations for the query elements, finding the k nearest neighbors in the rss space (euclidean distance).
%   samples and query: rss values of training and test samples, respectively
%   positions: locations associated to training rss values
%   k: number of neighbors
%
%   See also probEstimation, stgKNNEstimation.

    [samplRows, ~] = size(samples);
    [queryRows,~] = size(query);
    prediction = zeros(queryRows, 3);
    
    if (k > samplRows)
        k = samplRows;
    end
    
    for i = (1:queryRows)
        repQuery = repmat(query(i,:),samplRows,1);
        sumDist = sqrt(sum((samples - repQuery).^2,2));
        [sortedDist, indices] = sort(sumDist, 1, 'ascend');
        
        D = sortedDist(1:k); IDX = indices(1:k);
    
        pos = positions(IDX,:);
        if (sum(D == 0) > 0)
            prediction(i,:) = pos(1,:);
        else
            floorMode = mode(pos(:,3));
            prediction(i,:) = [mean(pos(:,[1,2]),1),floorMode];
        end
    end
end


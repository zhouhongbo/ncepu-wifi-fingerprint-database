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

function [prediction] = stgKNNEstimation(samples, query, positions, stgValue, k)
%stgKNNEstimation  Estimate locations for the query elements, first filtering samples whose strongest APs match those of the queries, and from those then finding the k nearest neighbors in the rss space.
%   samples and query: rss values of training and test samples, respectively
%   positions: locations associated to training rss values
%   stgValue: number of strongest AP for filtering
%   kValue: number of neighbors
%   See also probEstimation, kNNEstimation.

    % Get a cell array, which can be indexes by AP number. The cell content
    % indicates the samples for which the indexing AP was their strongest AP.
    [samplesList] = stgSmplsPerAP(samples, stgValue);

    prediction = [];
    
    for i = (1:size(query,1))   % For each query sample
        fingerprint = query(i,:);
        % Find the strongest AP in the query sample
        [minIndexes] = findMaxs(fingerprint, stgValue);
        % Get training samples whose strongest APs match those of the query
        selected = samplesList(minIndexes);
        allFPIndexes = cat(2, selected{:}); % transform the cell into an array
        % Apply kNN over the training selection 
        kNNPrediction = kNNEstimation(samples(allFPIndexes,:), fingerprint, positions(allFPIndexes,:), k);
        prediction = [prediction;kNNPrediction];
    end
end


function [samplesList] = stgSmplsPerAP(RSS,stgValue)
    rSize = size(RSS);
    maxs = false(rSize);
    rowIndexes = (1:rSize(1));
    samplesList = cell(1,rSize(2));
    for i = rowIndexes
        fingerprint = RSS(i,:);
        [minIndexes] = findMaxs(fingerprint, stgValue);
        maxs(i,minIndexes) = true;
    end
    for j = (1:rSize(2))
        samplesList{j} = rowIndexes(maxs(:,j));
    end
end
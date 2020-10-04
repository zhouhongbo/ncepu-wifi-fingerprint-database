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

function [prediction] = probEstimation(samples, query, positions, k, ids)
%probEstimation  Estimate locations for the query elements, using the probabilistic approach.
%   samples and query: rss values of training and test samples, respectively
%   positions: locations associated to training rss values
%   k: number of neighbors used to produce the estimation
%   ids: When provided, the means and stds are computed for unique points defined by ids. Otherwise, they are computed using unique locations defined by positions.
%   See also kNNEstimation, stgKNNEstimation.

    [M,S, pos] = getMeanAndStd(samples, positions, ids);
    PROBS = probs(M, S, query);
    [prediction] = estimatesKNN(PROBS, pos, k);
end
    
function [estimates] = estimatesKNN(PROBS, positions, k)
    estimates = zeros(size(PROBS,2),3);
    nRows = size(PROBS, 2);
    [~,I] = sort(PROBS, 1, 'descend');
    for i = (1:nRows)
        xs = positions(:,1);
        ys = positions(:,2);
        floor = positions(:,3);
        estimates(i,1) = mean(xs(I(1:k,i)));
        estimates(i,2) = mean(ys(I(1:k,i)));
        estimates(i,3) = mode(floor(I(1:k,i)));
    end
end
    
function [PROBS] = probs(M, S, query)
    nRowsT = size(M, 1);
    nRowsV = size(query, 1);
    PROBS = zeros(nRowsT, nRowsV);
    
    for v = (1:nRowsV)
        fp = query(v,:);
        estP = probsFP(M, S, fp);
        PROBS(:, v) = estP;
    end
end

function [P] = probsFP(M, S, fp)
    e = 0.5;
    nRowsT = size(M,1);
    FP1 = repmat(fp - e, nRowsT, 1);
    FP2 = repmat(fp + e, nRowsT, 1);
    D1 = normcdf(FP1, M, S);
    D2 = normcdf(FP2, M, S);
    PROBS = D2 - D1;
    
    PROBS(PROBS==0) = 1e-24;
    
    P = prod(PROBS, 2);
end

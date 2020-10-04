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

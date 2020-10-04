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


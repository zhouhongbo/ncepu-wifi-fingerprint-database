function [estimates] = randomEstimation(samples, query, positions, k)
    [pos, ~, ~] = unique(positions, 'rows');
    nPoints = size(pos,1);
    nQuery = size(query,1);
    neighbors = ceil(nPoints*rand(nQuery,k));   % Get a random position
    estimates = zeros(nQuery,3);
    
    for i = (1:nQuery)
        ns = neighbors(1,:);
        estimates(i,1) = mean(pos(ns,1));
        estimates(i,2) = mean(pos(ns,2));
        estimates(i,3) = mode(pos(ns,3));
    end
end
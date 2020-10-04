function [minIndexes] = findMaxs(fingerprint, k)
% findMaxs  Get AP positions that correspond to the k strongest values found in fingerprint.
%
%   See also stgKNNEstimation.

    [B,~] = sort(fingerprint,'descend');
    minIndexes = false(1,length(fingerprint));
    for v = (1:k)
        minIndexes = minIndexes | (fingerprint==B(v));
    end
end
function [M, S, pos] = getMeanAndStd(samples, locations, ids)
%{
获取训练集样本的均值和均方差

Args:
    samples: 训练集样本
    positions: 训练集样本的位置
    ids: 训练集样本的ID

Returns:
    M: 均值
    S: 均方差
    pos: 位置
%}
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
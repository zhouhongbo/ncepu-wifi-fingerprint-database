% stg方法，是KNN方法的一种改进方法
% 
% Args:
%     samples: 训练集样本
%     query: 测试集样本
%     positions: 训练集样本的位置
%     stgValue: 信号最强AP的个数
%     k: 最近邻个数
% 
% Returns:
%     prediction (ndarray): 预测位置
function [prediction] = stgKNNEstimation(samples, query, positions, stgValue, k)
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
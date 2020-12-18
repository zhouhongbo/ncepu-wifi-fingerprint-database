% 实现KNN方法
% 
% Args:
%     samples: 训练集样本
%     query: 测试集样本
%     positions: 训练集样本的位置
%     k: 最近邻个数
% 
% Returns:
%     prediction: 预测位置
function [prediction] = kNNEstimation(samples, query, positions, k)
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
        if (sum(D == 0) > 0) % 若存在某训练集样本与测试集样本的欧氏距离为0，则预测位置为该训练集样本的位置
            prediction(i,:) = pos(1,:);
        else
            floorMode = mode(pos(:,3));
            prediction(i,:) = [mean(pos(:,[1,2]),1),floorMode];
        end
    end
end


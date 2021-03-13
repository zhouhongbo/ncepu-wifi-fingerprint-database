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
function [prediction] = kNN5g(samples, query, positions, k, threshold)
    [samplRows, ~] = size(samples);
    [queryRows,~] = size(query);
    prediction = zeros(queryRows, 3);
    
    if (k > samplRows)
        k = samplRows;
    end
    
    for i = (1:queryRows)
        queryRow = query(i,:);
        cols(1:2:19) = repelem(true, 10); % 计算符合阈值的列
        cols(2:2:20) = queryRow(2:2:20) > threshold; 
        repQuery = repmat(query(i, cols),samplRows,1);
        sumDist = sqrt(sum((samples(:, cols) - repQuery).^2,2));
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


% 基于概率的方法
% 
% Args:
%     samples: 训练集样本
%     query: 测试集样本
%     positions: 训练集样本的位置
%     k: 最近邻个数
%     ids: 样本的ID（需要把特征值删除），根据这个参数把具有相同特征的训练集样本分组
% 
% Returns:
%     prediction: 预测位置
function [prediction] = probEstimation(samples, query, positions, k, ids)
    [M,S, pos] = getMeanAndStd(samples, positions, ids);
    PROBS = probs(M, S, query);
    [prediction] = estimatesKNN(PROBS, pos, k);
end

% 比较概率值的KNN方法
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

% 计算测试集样本的每一个数据出现在对应AP的概率
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

% 计算PROBS变量的一列
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

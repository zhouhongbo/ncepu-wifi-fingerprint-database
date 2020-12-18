function [minIndexes] = findMaxs(fingerprint, k)
%{
找到测试样本中最强k个AP的下标

Args:
    fingerprint: 一个测试样本
    k: 最强AP的数量
Returns:
    minIndexes: 测试样本中最强k个AP的下标
%}

    [B,~] = sort(fingerprint,'descend');
    minIndexes = false(1,length(fingerprint));
    for v = (1:k)
        minIndexes = minIndexes | (fingerprint==B(v));
    end
end
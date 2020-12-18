% 根据样本编号的范围[1, 10]处理ID
function [result] = findSamplesInRage(pointIds, minVal, maxVal)
    digits = rem(pointIds, 10^2);
    result = (digits >= minVal)&((digits <= maxVal));
end
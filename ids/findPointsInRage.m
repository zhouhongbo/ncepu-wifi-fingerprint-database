% 根据结点的编号范围处理ID
function [result] = findPointsInRage(pointIds, minVal, maxVal)
    digits = rem(floor(pointIds./10^2), 10^3);
    result = (digits >= minVal)&((digits <= maxVal));
end
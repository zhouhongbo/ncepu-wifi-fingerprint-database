% 根据结点的编号处理ID
function [result] = findPoint(pointIds, pointNumber)
    result = findPointsInRage(pointIds, pointNumber, pointNumber);
end
function [e,fsr] = customError(estimationPos, actualPos, floorPenalty)
%{
计算预测位置与实际位置之间的误差

Args:
    estimationPos: 预测位置
    actualPos: 实际位置

Returns:
    e: 误差
    fsr: 楼层判断误差
%}
    e = sqrt(sum((estimationPos(:,[1,2])-actualPos(:,[1,2])).^2, 2));
    if (~exist('floorPenalty', 'var'))
        floorPenalty = 5;
    end
    fDiff = abs(estimationPos(:,3) - actualPos(:,3));
    fsr = sum(fDiff==0)/size(actualPos,1);
    penalty = fDiff*floorPenalty;
    e = e + penalty;
end
% 根据campNumber参数处理ID,样本所在数据集的编号
function [result] = findCampNumber(pointIds, campNumber)
    digits = rem(floor(pointIds./10^6), 10^2);
    result = digits == campNumber;
end
% 根据样本的编号处理ID
function [result] = findSample(pointIds, sampleNumber)
    result = findSamplesInRage(pointIds, sampleNumber, sampleNumber);
end
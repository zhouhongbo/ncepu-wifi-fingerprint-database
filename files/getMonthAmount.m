function [monthAmount] = getMonthAmount(dirPath)
% getMonthAmount  Utility. Get the amount of collection month (folders) in dirPath 
%
    list = getDirContent(dirPath, 1);
    monthAmount = length(sort(list));
end
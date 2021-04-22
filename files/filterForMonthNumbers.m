function [result] = filterForMonthNumbers(dirAndFileNames, monthNumbers)
% filterForMonthNumbers  Utility.
%
%   See also getFileNameDefs.
    [~,~,ic] = unique(dirAndFileNames(:,1));
    % 暂时解决反向数据集的读取bug
    if monthNumbers == 95
        ic(ic == 7) = 95;
    end
    result = false(1,size(dirAndFileNames,1));
    for monthNumber = monthNumbers
        result = result | (ic == monthNumber)';
    end
end
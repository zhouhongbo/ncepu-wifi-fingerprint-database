function [result] = filterForMonthNumbers(dirAndFileNames, monthNumbers)
% filterForMonthNumbers  Utility.
%
%   See also getFileNameDefs.
    [~,~,ic] = unique(dirAndFileNames(:,1));
    result = false(1,size(dirAndFileNames,1));
    for monthNumber = monthNumbers
        result = result | (ic == monthNumber)';
    end
end
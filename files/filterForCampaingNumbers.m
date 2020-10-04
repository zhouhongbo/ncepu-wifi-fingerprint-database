function [result] = filterForCampaingNumbers(dirAndFileNames, campaingNumbers)
% filterForCampaingNumbers  Utility. Get files names from dirAndFileNames
% that match the campaign numbers, supplied in campaingNumbers as an array 
%
%   See also getFileNameDefs.
    numbers = str2double(extractBetween(dirAndFileNames(:,2), 4, 5));
    result = false(1,size(dirAndFileNames,1));
    for campaingNumber = campaingNumbers
        result = result | (numbers == campaingNumber)';
    end
end
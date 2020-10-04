function [result] = filterFileNames(dirAndFileNames, trainOrTest, campaingNumbers, monthNumbers, defs)
% filterFileNames  Utility. Get files names from dirAndFileNames match the
% filtering options
%
%   See also getFileNameDefs.
    result = true(1,size(dirAndFileNames,1));
    result = result & filterForTrainOrTest(dirAndFileNames, trainOrTest, defs);
    result = result & filterForCampaingNumbers(dirAndFileNames, campaingNumbers);
    result = result & filterForMonthNumbers(dirAndFileNames, monthNumbers);
end
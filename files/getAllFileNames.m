function [dirAndFileNames] = getAllFileNames(dataFolder, defs)
% getAllFileNames  Utility. Get all file names from the specified folder
%
%   See also getFileNameDefs, getDirContent.
    dirAndFileNames = {};
    dirs = getDirContent(dataFolder, 1);
    for dir = (1:length(dirs))
        files = getDirContent(strcat(dataFolder,'/',dirs{dir}), 0);
        uniqueFileNames = rmPartsAndExt(files, defs);
        dirAndFileNames = [dirAndFileNames;[repmat(dirs(dir), size(uniqueFileNames))',uniqueFileNames']];
    end
    dirAndFileNames = sortrows(dirAndFileNames,1);
end
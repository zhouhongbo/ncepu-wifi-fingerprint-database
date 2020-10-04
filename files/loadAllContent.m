function [data] = loadAllContent(dataFolder)
% loadAllContent  Load all the datasets from the database.
% dataFolder: path to folder where the database is
% data: struct with rss, coords, time and ids field containig all loaded data
%
%   See also loadContentSpecific.
    defs = getFileNameDefs();
    fileNames = getAllFileNames(dataFolder, defs);
    result = true(1,size(fileNames,1));
    data = loadContent(dataFolder, fileNames, result, defs);
end
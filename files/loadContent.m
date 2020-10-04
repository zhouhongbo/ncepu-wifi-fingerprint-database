function [data] = loadContent(dataFolder, fileNames, result, defs)
% loadContent  Utility. Load the content of datasets whose file names by indexing 
% fileNames using result
% data: struct with rss, coords, time and ids field containig all loaded data
%
%   See also getFileNameDefs.
    data = struct;
    data.rss = [];
    data.coords = [];
    data.time = [];
    data.ids = [];
    selectedFN = fileNames(result,:);
    for i = (1:size(selectedFN,1))
        fileContent = composeFileContent(selectedFN{i,2}, strcat(dataFolder,'/',selectedFN{i,1}), defs);
        
        data.rss = [data.rss;fileContent.rss];
        data.coords = [data.coords;fileContent.coords];
        data.time = [data.time;fileContent.time];
        data.ids = [data.ids;fileContent.ids];
    end
end
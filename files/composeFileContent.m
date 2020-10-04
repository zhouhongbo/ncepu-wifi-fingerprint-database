function [fileContent] = composeFileContent(fileName, dataFolder, defs)
% composeFileContent  Utility. Reads a dataset into a struct.
%
%   See also getFileNameDefs.
    fileContent = struct;
    fileContent.rss = csvread(strcat(dataFolder,'/',fileName,defs.rss,'.csv'));
    fileContent.coords = csvread(strcat(dataFolder,'/',fileName,defs.coords,'.csv'));
    fileContent.time = csvread(strcat(dataFolder,'/',fileName,defs.time,'.csv'));
    fileContent.ids = csvread(strcat(dataFolder,'/',fileName,defs.ids,'.csv'));
end
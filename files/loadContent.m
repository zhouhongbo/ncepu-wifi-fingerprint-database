% Copyright © 2017 Universitat Jaume I (UJI)
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of
% this software and associated documentation files (the “Software”), to deal in
% the Software without restriction, including without limitation the rights to
% use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
% of the Software, and to permit persons to whom the Software is furnished to do
% so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

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
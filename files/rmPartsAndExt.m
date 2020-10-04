function [result] = rmPartsAndExt(fileNames, defs)
% rmPartsAndExt  Utility. Determine names of files containing information of
% datasets specified by fileNames
%
%   See also getFileNameDefs.
    fileNames = strrep(fileNames,defs.rss,'');
    fileNames = strrep(fileNames,defs.coords,'');
    fileNames = strrep(fileNames,defs.time,'');
    fileNames = strrep(fileNames,defs.ids,'');
    fileNames = strrep(fileNames,'.csv','');
    result = unique(fileNames);
end
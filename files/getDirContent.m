function [list] = getDirContent(dirPath, dirOrFile)
% getDirContent  Get name of directories (dirOrFile==1) or files (dirOrFile~=1) 
% contained in the folder specified by path.
%
%   See also getFileNameDefs.
    oldFolder = cd(dirPath);
    listing = dir('.');
    cd(oldFolder);
    list = {listing.name};
    if (dirOrFile == 1) % dir
        list(~[listing.isdir])=[];
        list(startsWith(list,'.') | startsWith(list,'..')) = [];
    else
        list([listing.isdir])=[];
    end
end
function [data] = loadContentSpecific(dataFolder, trainOrTest, campaingNumbers, monthNumbers)
% loadContentSpecific  Load the datasets with the specified
% characteristics.
% dataFolder: path to folder where the database is
% trainOrTest: both(0), just training(1), just test(2)
% campaingNumbers: up to 2 digit integer numbers
% monthNumbers: up to 2 digit integer numbers array
% data: struct with rss, coords, time and ids field containig all loaded data
%
%   See also loadAllContent.
% dataFolder: 'db'
% trainOrTest: 1 训练集
% campaingNumbers: [1, 2] 训练集1和训练集2
% monthNumbers: 2 第2个月
    defs = getFileNameDefs();
    fileNames = getAllFileNames(dataFolder, defs);
    result = filterFileNames(fileNames, trainOrTest, campaingNumbers, monthNumbers, defs);
    data = loadContent(dataFolder, fileNames, result, defs);
end
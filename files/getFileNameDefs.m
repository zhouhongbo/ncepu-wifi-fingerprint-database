function [defs] = getFileNameDefs()
% getFileNameDefs  Utility. Defines file naming parts of datasets.
% defs: 与文件名相关的结构体
    defs = struct;
    defs.test = 'tst';
    defs.train = 'trn';
    defs.rss = 'rss';
    defs.ids = 'ids';
    defs.time = 'tms';
    defs.coords = 'crd';
end


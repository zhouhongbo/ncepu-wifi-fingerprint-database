function [defs] = getFileNameDefs()
% getFileNameDefs  Utility. Defines file naming parts of datasets.
%
    defs = struct;
    defs.test = 'tst';
    defs.train = 'trn';
    defs.rss = 'rss';
    defs.ids = 'ids';
    defs.time = 'tms';
    defs.coords = 'crd';
end


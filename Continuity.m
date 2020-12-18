% Script to generate the paper's figures "Sample1Scatter" and "Sample6Scatter"
% as well as data for table "rssDiffSamples".

chosenMonth = 2;
chosenAP = 3; % 选哪个AP的数据，范围[1, 10]

close all;

addpath('db','files','ids','ips');

% Load datasets from month 1
dataTest = loadContentSpecific('db', 2, [2, 4, 6, 8], chosenMonth);
dataTrain = loadContentSpecific('db', 1, [2, 4], chosenMonth);

data = struct;
data.coords = [dataTest.coords;dataTrain.coords];
data.time = [dataTest.time;dataTrain.time];
data.ids = [dataTest.ids;dataTrain.ids];
data.rss = [dataTest.rss(:,chosenAP);dataTrain.rss(:,chosenAP)];
data.rss(data.rss==100) = nan;

% 2.4g频率
ap24 = chosenAP * 2 - 1; % 选择AP编号
data.rss = [dataTest.rss(:,ap24);dataTrain.rss(:,ap24)];
data.rss(data.rss==100) = nan;

sNumber = 10; % 选第10个样本
inds = findSample(data.ids, sNumber);

figure('PaperUnits','centimeters','PaperSize',[20,20],'PaperPosition',[0 0 20 20]);
scatter(data.coords(inds,1),data.coords(inds,2),[],data.rss(inds,:), 'filled', 'MarkerEdgeColor', 'k');
caxis([-110, -40]);

xlabel('x');
ylabel('y');
title(['AP', num2str(chosenAP), ' 2.4g']); % 设置标题
cbh = colorbar;
ylabel(cbh, 'dBm');
colormap(jet);

xlim([-2 31]);
ylim([-1 30]);
axis square;
set(gca,'XDir','reverse'); %将x轴方向设置为反向(从右到左递增)

hold on;
nanVInd = isnan(data.rss);
scatter(data.coords(inds&nanVInd,1),data.coords(inds&nanVInd,2),[],data.rss(inds&nanVInd,:), 'filled', 'MarkerFaceColor', 'k');

% 5g频率
ap5 = chosenAP * 2; % 选择AP编号
data.rss = [dataTest.rss(:,ap5);dataTrain.rss(:,ap5)];
data.rss(data.rss==100) = nan;

sNumber = 10; % 选第10个样本
inds = findSample(data.ids, sNumber);

figure('PaperUnits','centimeters','PaperSize',[20,20],'PaperPosition',[0 0 20 20]);
scatter(data.coords(inds,1),data.coords(inds,2),[],data.rss(inds,:), 'filled', 'MarkerEdgeColor', 'k');
caxis([-110, -40]);

xlabel('x');
ylabel('y');
title(['AP', num2str(chosenAP), ' 5g']);
cbh = colorbar;
ylabel(cbh, 'dBm');
colormap(jet);

xlim([-2 31]);
ylim([-1 30]);
axis square;
set(gca,'XDir','reverse'); %将x轴方向设置为反向(从右到左递增)

hold on;
nanVInd = isnan(data.rss);
scatter(data.coords(inds&nanVInd,1),data.coords(inds&nanVInd,2),[],data.rss(inds&nanVInd,:), 'filled', 'MarkerFaceColor', 'k');


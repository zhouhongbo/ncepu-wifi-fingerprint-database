% Script to generate the paper's figure "Charting3rd" and "Charting5th"

chosenAP = 3; % 选哪个AP的数据，范围[1, 10]

close all;
addpath('db','files','ids','ips');

ap24 = chosenAP * 2 - 1;
ap5 = chosenAP * 2;
barWidth = 0.25;

data = loadContentSpecific('db', 2, [2, 4, 6, 8], 1); % 所有训练集
data.rss(data.rss==100) = nan;

% 2.4g频率
[M, S, pos] = getMeanAndStd(data.rss(:,ap24),data.coords); % 验证过没错
drawRssBars(pos(:,1), pos(:,2), barWidth, M(:,:), S(:,:), ['AP', num2str(chosenAP), ' 2.4g']);
set(gca,'XDir','reverse'); %将x轴方向设置为反向(从右到左递增)

% 5g频率
[M, S, pos] = getMeanAndStd(data.rss(:,ap5),data.coords); % 12 samples considered per location
drawRssBars(pos(:,1), pos(:,2), barWidth, M(:,:), S(:,:), ['AP', num2str(chosenAP), ' 5g']);
set(gca,'XDir','reverse'); %将x轴方向设置为反向(从右到左递增)

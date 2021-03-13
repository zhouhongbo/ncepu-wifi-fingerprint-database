% 2.4g频率信号和5g频率信号融合定位

chosenMonth = 1;

close all; % 删除其句柄未隐藏的所有图窗
addpath('db','files','ids','ips'); % 向搜索路径中添加文件夹

% Common to all methods
mounthAmount = 1;
notDetected = 100;
monthRange = (1:mounthAmount);

% Storage for 2D error
metricProb = zeros(1, mounthAmount);
metricKnn = zeros(1, mounthAmount);
metricNn = zeros(1, mounthAmount);
metricStg = zeros(1, mounthAmount);
metricGk = zeros(1, mounthAmount);

% load current month data
dataTrain = loadContentSpecific('db', 1, [2, 4], chosenMonth); % 用晚上的数据
dataTest = loadContentSpecific('db', 2, [2, 4, 6, 8], chosenMonth); % 用晚上的数据

% deal with not seen AP
dataTrain.rss(dataTrain.rss==100) = -105;
dataTest.rss(dataTest.rss==100) = -105;

% 2.4g信号
dataTrain24.rss = dataTrain.rss(:, 1:2:19);
dataTrain24.coords = dataTrain.coords;
dataTrain24.time = dataTrain.time;
dataTrain24.ids = dataTrain.ids;

dataTest24.rss = dataTest.rss(:, 1:2:19);
dataTest24.coords = dataTest.coords;
dataTest24.time = dataTest.time;
dataTest24.ids = dataTest.ids;

% 5g信号
dataTrain5.rss = dataTrain.rss(:, 2:2:20);
dataTrain5.coords = dataTrain.coords;
dataTrain5.time = dataTrain.time;
dataTrain5.ids = dataTrain.ids;

dataTest5.rss = dataTest.rss(:, 2:2:20);
dataTest5.coords = dataTest.coords;
dataTest5.time = dataTest.time;
dataTest5.ids = dataTest.ids;

% kNN 2.4g和5g
knnValue = 10;    % Number of neighbors
predictionKnn = kNNEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, knnValue);
[errorKnn, ~] = customError(predictionKnn, dataTest.coords, 0);
metricKnn(1, chosenMonth) = getMetric(errorKnn);
disp(['2.4g和5g：', num2str(metricKnn)]);

% kNN 2.4g
knnValue = 10;    % Number of neighbors
predictionKnn = kNNEstimation(dataTrain24.rss, dataTest24.rss, dataTrain24.coords, knnValue);
[errorKnn, ~] = customError(predictionKnn, dataTest24.coords, 0);
metricKnn(1, chosenMonth) = getMetric(errorKnn);
disp(['2.4g：', num2str(metricKnn)]);

% kNN 5g
knnValue = 10;    % Number of neighbors
predictionKnn = kNNEstimation(dataTrain5.rss, dataTest5.rss, dataTrain5.coords, knnValue);
[errorKnn, ~] = customError(predictionKnn, dataTest5.coords, 0);
metricKnn(1, chosenMonth) = getMetric(errorKnn);
disp(['5g：', num2str(metricKnn)]);

% kNN 2.4g和5g融合
knnValue = 10;    % Number of neighbors
threshold = -100; % 5g信号小于threshold的就删除
predictionKnn = kNN5g(dataTrain.rss, dataTest.rss, dataTrain.coords, knnValue, threshold);
[errorKnn, ~] = customError(predictionKnn, dataTest.coords, 0);
metricKnn(1, chosenMonth) = getMetric(errorKnn);
disp(['2.4g和5g：', num2str(metricKnn)]);

% 寻找最合适阈值
min = -95;
max = -30;
x = min:max;
y = ones(1, max-min+1);
i = 1;
for threshold = (min:max)
    knnValue = 10;    % Number of neighbors
    predictionKnn = kNN5g(dataTrain.rss, dataTest.rss, dataTrain.coords, knnValue, threshold);
    [errorKnn, ~] = customError(predictionKnn, dataTest.coords, 0);
    metricKnn(1, chosenMonth) = getMetric(errorKnn);
    disp(['2.4g和5g：', num2str(metricKnn)]);
    y(i) = metricKnn;
    i = i + 1;
%     scatter(threshold, metricKnn)
%     hold on
end
figure('PaperUnits','centimeters','PaperSize',[40,20],'PaperPosition',[0 0 40 20]); hold on;
plot(x, y);
xlabel('阈值','fontsize',16);
ylabel('75定位误差','fontsize',16);
grid on;

% 计算75%定位误差
function [metric] = getMetric(errors)
    metric = prctile(errors, 75);
end
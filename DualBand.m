% 双频段定位

chosenMonth = 1;

close all; % 删除其句柄未隐藏的所有图窗
addpath('db','files','ids','ips'); % 向搜索路径中添加文件夹

% load current month data
dataTrain = loadContentSpecific('db', 1, [2, 4], chosenMonth); % 用晚上的数据
dataTest = loadContentSpecific('db', 2, [2, 4, 6, 8], chosenMonth); % 用晚上的数据

% deal with not seen AP
dataTrain.rss(dataTrain.rss==100) = -105;
dataTest.rss(dataTest.rss==100) = -105;

% 2.4g信号数据
dataTrain24.rss = dataTrain.rss(:, 1:2:19);
dataTrain24.coords = dataTrain.coords;
dataTrain24.time = dataTrain.time;
dataTrain24.ids = dataTrain.ids;

dataTest24.rss = dataTest.rss(:, 1:2:19);
dataTest24.coords = dataTest.coords;
dataTest24.time = dataTest.time;
dataTest24.ids = dataTest.ids;

% 5g信号数据
dataTrain5.rss = dataTrain.rss(:, 2:2:20);
dataTrain5.coords = dataTrain.coords;
dataTrain5.time = dataTrain.time;
dataTrain5.ids = dataTrain.ids;

dataTest5.rss = dataTest.rss(:, 2:2:20);
dataTest5.coords = dataTest.coords;
dataTest5.time = dataTest.time;
dataTest5.ids = dataTest.ids;

% kNN 2.4g
knnValue = 10;
predictionKnn = kNNEstimation(dataTrain24.rss, dataTest24.rss, dataTrain24.coords, knnValue);
[errorKnn, ~] = customError(predictionKnn, dataTest24.coords, 0);
metricKnn = getMetric(errorKnn);

disp('2.4g：');
disp(['平均误差：', num2str(mean(errorKnn))])
disp(['68%概率误差：', num2str(prctile(errorKnn, 68))])
disp(['75%概率误差：', num2str(metricKnn(1))])
disp(['95%概率误差：', num2str(prctile(errorKnn, 95))])
disp(['误差标准差：', num2str(std(errorKnn))])
disp(['1m概率：', num2str(sum(errorKnn <= 1)/ size(errorKnn, 1))])
disp(['2m概率：', num2str(sum(errorKnn <= 2)/ size(errorKnn, 1))])
disp(['3m概率：', num2str(sum(errorKnn <= 3)/ size(errorKnn, 1))])

h1 = cdfplot(errorKnn);
hold on

% kNN 5g
knnValue = 10;
predictionKnn = kNNEstimation(dataTrain5.rss, dataTest5.rss, dataTrain5.coords, knnValue);
[errorKnn, ~] = customError(predictionKnn, dataTest5.coords, 0);
metricKnn = getMetric(errorKnn);

disp('5g：');
disp(['平均误差：', num2str(mean(errorKnn))])
disp(['68%概率误差：', num2str(prctile(errorKnn, 68))])
disp(['75%概率误差：', num2str(metricKnn(1))])
disp(['95%概率误差：', num2str(prctile(errorKnn, 95))])
disp(['误差标准差：', num2str(std(errorKnn))])
disp(['1m概率：', num2str(sum(errorKnn <= 1)/ size(errorKnn, 1))])
disp(['2m概率：', num2str(sum(errorKnn <= 2)/ size(errorKnn, 1))])
disp(['3m概率：', num2str(sum(errorKnn <= 3)/ size(errorKnn, 1))])

h2 = cdfplot(errorKnn);
set(h2, 'LineStyle', '--');

% kNN 2.4g和5g混合
knnValue = 10;
predictionKnn = kNNEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, knnValue);
[errorKnn, ~] = customError(predictionKnn, dataTest.coords, 0);
metricKnn = getMetric(errorKnn);

disp('混合');
disp(['平均误差：', num2str(mean(errorKnn))])
disp(['68%概率误差：', num2str(prctile(errorKnn, 68))])
disp(['75%概率误差：', num2str(metricKnn(1))])
disp(['95%概率误差：', num2str(prctile(errorKnn, 95))])
disp(['误差标准差：', num2str(std(errorKnn))])
disp(['1m概率：', num2str(sum(errorKnn <= 1)/ size(errorKnn, 1))])
disp(['2m概率：', num2str(sum(errorKnn <= 2)/ size(errorKnn, 1))])
disp(['3m概率：', num2str(sum(errorKnn <= 3)/ size(errorKnn, 1))])

h3 = cdfplot(errorKnn);
set(h3, 'LineStyle', ':');

% kNN 阈值选择
knnValue = 10;
threshold = -92; % 阈值，5g信号小于threshold的就删除
predictionKnn = kNN5g(dataTrain.rss, dataTest.rss, dataTrain.coords, knnValue, threshold);
[errorKnn, ~] = customError(predictionKnn, dataTest.coords, 0);
metricKnn = getMetric(errorKnn);

disp('阈值选择');
disp(['平均误差：', num2str(mean(errorKnn))])
disp(['68%概率误差：', num2str(prctile(errorKnn, 68))])
disp(['75%概率误差：', num2str(metricKnn(1))])
disp(['95%概率误差：', num2str(prctile(errorKnn, 95))])
disp(['误差标准差：', num2str(std(errorKnn))])
disp(['1m概率：', num2str(sum(errorKnn <= 1)/ size(errorKnn, 1))])
disp(['2m概率：', num2str(sum(errorKnn <= 2)/ size(errorKnn, 1))])
disp(['3m概率：', num2str(sum(errorKnn <= 3)/ size(errorKnn, 1))])

h4 = cdfplot(errorKnn);
set(h4, 'LineStyle', '-.');
xlabel('误差/m')
ylabel('CDF')
title('')
legend('2.4GHz', '5GHz', '混合', '阈值选择')
set(gca, 'fontsize', 10.5, 'fontname', '宋体');
box off
hold off

% 寻找最合适阈值 -92
min = -95;
max = -30;
x = min:max;
y = ones(1, max-min+1);
i = 1;
for threshold = (min:max)
    knnValue = 10;
    predictionKnn = kNN5g(dataTrain.rss, dataTest.rss, dataTrain.coords, knnValue, threshold);
    [errorKnn, ~] = customError(predictionKnn, dataTest.coords, 0);
    metricKnn = getMetric(errorKnn);
    disp(['2.4g和5g：', num2str(metricKnn)]);
    y(i) = metricKnn;
    i = i + 1;
%     scatter(threshold, metricKnn)
%     hold on
end
figure;
plot(x, y);
xlabel('阈值/dBm');
ylabel('75%概率误差/m');
grid on;
set(gca, 'fontsize', 10.5, 'fontname', '宋体');
set(gca,'XDir','reverse');
box off

% 计算75%定位误差
function [metric] = getMetric(errors)
    metric = prctile(errors, 75);
end
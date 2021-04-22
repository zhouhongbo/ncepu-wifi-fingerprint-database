% k值的选择
chosenMonth = 1;

close all; % 删除其句柄未隐藏的所有图窗
addpath('db','files','ids','ips'); % 向搜索路径中添加文件夹

% load current month data
dataTrain = loadContentSpecific('db', 1, [2, 4], chosenMonth); % 用晚上的数据
dataTest = loadContentSpecific('db', 2, [2, 4, 6, 8], chosenMonth); % 用晚上的数据

% deal with not seen AP
dataTrain.rss(dataTrain.rss==100) = -105;
dataTest.rss(dataTest.rss==100) = -105;

% kNN
% 选择合适的k值
min = 1;
max = 20;
x = min:max;
y = zeros(1, max-min+1); % 75%误差
i = 1;
for k = (min:max)
    predictionKnn = kNNEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, k);
    [errorKnn, ~] = customError(predictionKnn, dataTest.coords, 0);
    metricKnn = getMetric(errorKnn);
    disp([k, metricKnn]);
    y(i) = metricKnn;
    i = i + 1;
end

plot(x, y)
xlabel('K值')
ylabel('75%概率误差/m')
grid
set(gca, 'fontsize', 10.5, 'fontname', '宋体');
box off

% 计算75%定位误差
function [metric] = getMetric(errors)
    metric = prctile(errors, 75);
end
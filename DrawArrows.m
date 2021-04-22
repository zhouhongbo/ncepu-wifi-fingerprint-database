% 画从实际点到预测点的箭头图

chosenMonth = 1;

close all; % 删除其句柄未隐藏的所有图窗
addpath('db','files','ids','ips'); % 向搜索路径中添加文件夹

% Common to all methods
mounthAmount = 1; % 第一个月
notDetected = 100;
monthRange = (1:mounthAmount);

% Storage for 2D error
metricProb = zeros(1, mounthAmount);
metricKnn = zeros(1, mounthAmount);
metricNn = zeros(1, mounthAmount);
metricStg = zeros(1, mounthAmount);
metricGk = zeros(1, mounthAmount);

% Storage for floor detection rate
rateProb = zeros(1, mounthAmount);
rateKnn = zeros(1, mounthAmount);
rateNn = zeros(1, mounthAmount);
rateStg = zeros(1, mounthAmount);
rateGk = zeros(1, mounthAmount);


% load current month data
dataTrain = loadContentSpecific('db', 1, [2, 4], chosenMonth); % 用晚上的数据
dataTest = loadContentSpecific('db', 2, [2, 4, 6, 8], chosenMonth); % 用晚上的数据

% deal with not seen AP
dataTrain.rss(dataTrain.rss==100) = -105;
dataTest.rss(dataTest.rss==100) = -105;

% Nn method estimation
knnValue = 1;    % Number of neighbors
[M, ~, pos] = getMeanAndStd(dataTest.rss, dataTest.coords);
predictionNn = kNNEstimation(dataTrain.rss, M, dataTrain.coords, knnValue);
[errorNn,fsrK] = customError(predictionNn, pos, 0);
metricNn(1, chosenMonth) = getMetric(errorNn);
rateNn(1, chosenMonth) = fsrK;

drawPoints();
xlabel('x/m')
ylabel('y/m')
set(gca, 'fontsize', 10.5, 'fontname', '宋体');
arrow(pos(:, 1:2), predictionNn(:, 1:2), 'Length', 5, 'BaseAngle', 20);

% kNN method estimation tst求平均
knnValue = 5;    % Number of neighbors
[M, ~, pos] = getMeanAndStd(dataTest.rss, dataTest.coords);
predictionKnn = kNNEstimation(dataTrain.rss, M, dataTrain.coords, knnValue);
[errorKnn,fsrK] = customError(predictionKnn, pos, 0);
metricKnn(1, chosenMonth) = getMetric(errorKnn);
rateKnn(1, chosenMonth) = fsrK;

drawPoints();
xlabel('x/m')
ylabel('y/m')
set(gca, 'fontsize', 10.5, 'fontname', '宋体');
arrow(pos(:, 1:2), predictionKnn(:, 1:2), 'Length', 5, 'BaseAngle', 20);

% Probabilistic method estimation tst求平均
kValue = 1;    % Single Point
[M, ~, pos] = getMeanAndStd(dataTest.rss, dataTest.coords);
[predictionProb] = probEstimation(dataTrain.rss, M, dataTrain.coords, kValue, floor(dataTrain.ids./100));
[errorProb,fsrP] = customError(predictionProb, pos, 0);
metricProb(1, chosenMonth) = getMetric(errorProb);
rateProb(1, chosenMonth) = fsrP;

drawPoints();
xlabel('x/m')
ylabel('y/m')
set(gca, 'fontsize', 10.5, 'fontname', '宋体');
arrow(pos(:, 1:2), predictionProb(:, 1:2), 'Length', 5, 'BaseAngle', 20);

% Stg method estimation tst求平均
stgValue = 3;    % AP filtering value
kValue = 5;    % Number of neighbors
[M, ~, pos] = getMeanAndStd(dataTest.rss, dataTest.coords);
predictionStg = stgKNNEstimation(dataTrain.rss, M, dataTrain.coords, stgValue, kValue);
[errorStg,fsrS] = customError(predictionStg, pos, 0);
metricStg(chosenMonth) = getMetric(errorStg);
rateStg(1, chosenMonth) = fsrS;

drawPoints();
xlabel('x/m')
ylabel('y/m')
set(gca, 'fontsize', 10.5, 'fontname', '宋体');
arrow(pos(:, 1:2), predictionStg(:, 1:2), 'Length', 5, 'BaseAngle', 20);

% Gk method estimation tst求平均
std_dB = 4; % (has almost no effect in this scenario)
kValue = 12;
[M, ~, pos] = getMeanAndStd(dataTest.rss, dataTest.coords);
predictionGk = gaussiankernelEstimation(dataTrain.rss, M, dataTrain.coords, std_dB, kValue);
[errorGk,fsrGk] = customError(predictionGk, pos, 0);
metricGk(1, chosenMonth) = getMetric(errorGk);
rateGk(1, chosenMonth) = fsrGk;

drawPoints();
xlabel('x/m')
ylabel('y/m')
set(gca, 'fontsize', 10.5, 'fontname', '宋体');
arrow(pos(:, 1:2), predictionGk(:, 1:2), 'Length', 5, 'BaseAngle', 20);

% 计算75%定位误差
function [metric] = getMetric(errors)
    metric = prctile(errors, 75);
end


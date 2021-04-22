close all; % 删除其句柄未隐藏的所有图窗

addpath('db','files','ids','ips'); % 向搜索路径中添加文件夹

% 所有定位算法通用的变量
month = 1; % month 看成week
notDetected = 100;

% 加载本周数据
dataTrain = loadContentSpecific('db', 1, [2, 4], month); % 用晚上的数据
dataTest = loadContentSpecific('db', 2, [2, 4, 6, 8], month); % 用晚上的数据

% 处理无信号AP的数据
dataTrain.rss(dataTrain.rss==100) = -105;
dataTest.rss(dataTest.rss==100) = -105;

% NN方法
knnValue = 1;    % 选取的邻居节点个数
predictionNn = kNNEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, knnValue);
[errorNn,fsrK] = customError(predictionNn, dataTest.coords, 0);
metricNn(1, month) = getMetric(errorNn);
rateNn(1, month) = fsrK;

disp('NN:')
disp(['平均误差：', num2str(mean(errorNn))])
disp(['75%概率误差：', num2str(metricNn(1))])
disp(['误差标准差：', num2str(std(errorNn))])

% KNN方法
knnValue = 5;    % 选取的邻居节点个数
predictionKnn = kNNEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, knnValue);
[errorKnn,fsrK] = customError(predictionKnn, dataTest.coords, 0);
metricKnn(1, month) = getMetric(errorKnn);
rateKnn(1, month) = fsrK;

disp('KNN:')
disp(['平均误差：', num2str(mean(errorKnn))])
disp(['75%概率误差：', num2str(metricKnn(1))])
disp(['误差标准差：', num2str(std(errorKnn))])

% Prob方法
kValue = 1;    % 选取概率最大节点的个数
[predictionProb] = probEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, kValue, floor(dataTrain.ids./100));
[errorProb,fsrP] = customError(predictionProb, dataTest.coords, 0);
metricProb(1, month) = getMetric(errorProb);
rateProb(1, month) = fsrP;

disp('Prob:')
disp(['平均误差：', num2str(mean(errorProb))])
disp(['75%概率误差：', num2str(metricProb(1))])
disp(['误差标准差：', num2str(std(errorProb))])

% Stg方法
stgValue = 3;    % 信号最强AP的个数
kValue = 5;    % 选取的邻居节点个数
predictionStg = stgKNNEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, stgValue, kValue);
[errorStg,fsrS] = customError(predictionStg, dataTest.coords, 0);
metricStg(month) = getMetric(errorStg);
rateStg(1, month) = fsrS;

disp('Stg:')
disp(['平均误差：', num2str(mean(errorStg))])
disp(['75%概率误差：', num2str(metricStg(1))])
disp(['误差标准差：', num2str(std(errorStg))])

% Gk方法
std_dB = 4; % 此参数影响不大
kValue = 12;
predictionGk = gaussiankernelEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, std_dB, kValue);
[errorGk,fsrGk] = customError(predictionGk, dataTest.coords, 0);
metricGk(1, month) = getMetric(errorGk);
rateGk(1, month) = fsrGk;

disp('GK:')
disp(['平均误差：', num2str(mean(errorGk))])
disp(['75%概率误差：', num2str(metricGk(1))])
disp(['误差标准差：', num2str(std(errorGk))])

% cdf图
h1 = cdfplot(errorNn);
hold on
h2 = cdfplot(errorKnn);
set(h2, 'LineStyle', '--');
h3 = cdfplot(errorProb);
set(h3, 'LineStyle', ':');
h4 = cdfplot(errorStg);
set(h4, 'LineStyle', '-.');
h5 = cdfplot(errorGk);
xlabel('误差/m')
ylabel('CDF')
title('')
legend('NN', 'KNN', 'Prob', 'Stg', 'Gk')
set(gca, 'fontsize', 10.5, 'fontname', '宋体');
box off
hold off

% 计算75%定位误差
function [metric] = getMetric(errors)
    metric = prctile(errors, 75);
end
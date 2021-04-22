close all; % 删除其句柄未隐藏的所有图窗

addpath('db','files','ids','ips'); % 向搜索路径中添加文件夹

% 所有定位算法通用的变量
month = 5; % month 看成week; 5为正向，95为反向

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
metricNn = getMetric(errorNn);
rateNn = fsrK;

disp('NN:')
disp(['平均误差：', num2str(mean(errorNn))])
disp(['75%概率误差：', num2str(metricNn(1))])
disp(['误差标准差：', num2str(std(errorNn))])

% KNN方法
knnValue = 5;    % 选取的邻居节点个数
predictionKnn = kNNEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, knnValue);
[errorKnn,fsrK] = customError(predictionKnn, dataTest.coords, 0);
metricKnn = getMetric(errorKnn);
rateKnn = fsrK;

disp('KNN:')
disp(['平均误差：', num2str(mean(errorKnn))])
disp(['75%概率误差：', num2str(metricKnn(1))])
disp(['误差标准差：', num2str(std(errorKnn))])

% Prob方法
kValue = 1;    % 选取概率最大节点的个数
[predictionProb] = probEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, kValue, floor(dataTrain.ids./100));
[errorProb,fsrP] = customError(predictionProb, dataTest.coords, 0);
metricProb = getMetric(errorProb);
rateProb = fsrP;

disp('Prob:')
disp(['平均误差：', num2str(mean(errorProb))])
disp(['75%概率误差：', num2str(metricProb(1))])
disp(['误差标准差：', num2str(std(errorProb))])

% Stg方法
stgValue = 3;    % 信号最强AP的个数
kValue = 5;    % 选取的邻居节点个数
predictionStg = stgKNNEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, stgValue, kValue);
[errorStg,fsrS] = customError(predictionStg, dataTest.coords, 0);
metricStg = getMetric(errorStg);
rateStg = fsrS;

disp('Stg:')
disp(['平均误差：', num2str(mean(errorStg))])
disp(['75%概率误差：', num2str(metricStg(1))])
disp(['误差标准差：', num2str(std(errorStg))])

% Gk方法
std_dB = 4; % 此参数影响不大
kValue = 12;
predictionGk = gaussiankernelEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, std_dB, kValue);
[errorGk,fsrGk] = customError(predictionGk, dataTest.coords, 0);
metricGk = getMetric(errorGk);
rateGk = fsrGk;

disp('GK:')
disp(['平均误差：', num2str(mean(errorGk))])
disp(['75%概率误差：', num2str(metricGk(1))])
disp(['误差标准差：', num2str(std(errorGk))])

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

% ---------------- 反方向 -----------
% 所有定位算法通用的变量
month = 95; % month 看成week; 5为正向，95为反向
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
metricNn = getMetric(errorNn);
rateNn = fsrK;

disp('NN:')
disp(['平均误差：', num2str(mean(errorNn))])
disp(['75%概率误差：', num2str(metricNn(1))])
disp(['误差标准差：', num2str(std(errorNn))])

% KNN方法
knnValue = 5;    % 选取的邻居节点个数
predictionKnn = kNNEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, knnValue);
[errorKnn,fsrK] = customError(predictionKnn, dataTest.coords, 0);
metricKnn = getMetric(errorKnn);
rateKnn = fsrK;

disp('KNN:')
disp(['平均误差：', num2str(mean(errorKnn))])
disp(['75%概率误差：', num2str(metricKnn(1))])
disp(['误差标准差：', num2str(std(errorKnn))])

% Prob方法
kValue = 1;    % 选取概率最大节点的个数
[predictionProb] = probEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, kValue, floor(dataTrain.ids./100));
[errorProb,fsrP] = customError(predictionProb, dataTest.coords, 0);
metricProb = getMetric(errorProb);
rateProb = fsrP;

disp('Prob:')
disp(['平均误差：', num2str(mean(errorProb))])
disp(['75%概率误差：', num2str(metricProb(1))])
disp(['误差标准差：', num2str(std(errorProb))])

% Stg方法
stgValue = 3;    % 信号最强AP的个数
kValue = 5;    % 选取的邻居节点个数
predictionStg = stgKNNEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, stgValue, kValue);
[errorStg,fsrS] = customError(predictionStg, dataTest.coords, 0);
metricStg = getMetric(errorStg);
rateStg = fsrS;

disp('Stg:')
disp(['平均误差：', num2str(mean(errorStg))])
disp(['75%概率误差：', num2str(metricStg(1))])
disp(['误差标准差：', num2str(std(errorStg))])

% Gk方法
std_dB = 4; % 此参数影响不大
kValue = 12;
predictionGk = gaussiankernelEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, std_dB, kValue);
[errorGk,fsrGk] = customError(predictionGk, dataTest.coords, 0);
metricGk = getMetric(errorGk);
rateGk = fsrGk;

disp('GK:')
disp(['平均误差：', num2str(mean(errorGk))])
disp(['75%概率误差：', num2str(metricGk(1))])
disp(['误差标准差：', num2str(std(errorGk))])

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
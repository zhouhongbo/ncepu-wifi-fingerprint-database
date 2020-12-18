% 对每周的数据分别使用所有的定位算法，计算75%定位误差并生成定位误差对比图

close all; % 删除其句柄未隐藏的所有图窗

addpath('db','files','ids','ips'); % 向搜索路径中添加文件夹

rng('default'); % 会生成相同的随机数，使随机方法每次结果都一样

% 所有定位算法通用的变量
monthAmount = 3; % month看作week
notDetected = 100;
monthRange = (1:monthAmount);

% 保存75%定位误差的变量
metricRand = zeros(1, monthAmount);
metricProb = zeros(1, monthAmount);
metricNn = zeros(1, monthAmount);
metricKnn = zeros(1, monthAmount);
metricStg = zeros(1, monthAmount);
metricGk = zeros(1, monthAmount);

% 保存楼层判断成功率的变量
rateRand = zeros(1, monthAmount);
rateProb = zeros(1, monthAmount);
rateNn = zeros(1, monthAmount);
rateKnn = zeros(1, monthAmount);
rateStg = zeros(1, monthAmount);
rateGk = zeros(1, monthAmount);

for month = monthRange
    % 加载本周数据
    dataTrain = loadContentSpecific('db', 1, [2, 4], month); % 用晚上的数据
    dataTest = loadContentSpecific('db', 2, [2, 4, 6, 8], month); % 用晚上的数据
    
    % 处理无信号AP的数据
    dataTrain.rss(dataTrain.rss==100) = -105;
    dataTest.rss(dataTest.rss==100) = -105;
    
    % Rand方法
    kAmount = 1;    % 随机选取的RP数
    [predictionRandom] = randomEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, kAmount);
    [errorRandom,fsrR] = customError(predictionRandom, dataTest.coords, 0);
    metricRand(1, month) = getMetric(errorRandom);
    rateRand(1, month) = fsrR;
    
    % Prob方法
    kValue = 1;    % 选取概率最大节点的个数
    [predictionProb] = probEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, kValue, floor(dataTrain.ids./100));
    [errorProb,fsrP] = customError(predictionProb, dataTest.coords, 0);
    metricProb(1, month) = getMetric(errorProb);
    rateProb(1, month) = fsrP;
    
    % NN方法
    knnValue = 1;    % 选取的邻居节点个数
    predictionNn = kNNEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, knnValue);
    [errorNn,fsrK] = customError(predictionNn, dataTest.coords, 0);
    metricNn(1, month) = getMetric(errorNn);
    rateNn(1, month) = fsrK;
    
    % KNN方法
    knnValue = 9;    % 选取的邻居节点个数
    predictionKnn = kNNEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, knnValue);
    [errorKnn,fsrK] = customError(predictionKnn, dataTest.coords, 0);
    metricKnn(1, month) = getMetric(errorKnn);
    rateKnn(1, month) = fsrK;
    
    % Stg方法
    stgValue = 3;    % 信号最强AP的个数
    kValue = 5;    % 选取的邻居节点个数
    predictionStg = stgKNNEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, stgValue, kValue);
    [errorStg,fsrS] = customError(predictionStg, dataTest.coords, 0);
    metricStg(month) = getMetric(errorStg);
    rateStg(1, month) = fsrS;
    
    % Gk方法
    std_dB = 4; % 此参数影响不大
    kValue = 12;
    predictionGk = gaussiankernelEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, std_dB, kValue);
    [errorGk,fsrGk] = customError(predictionGk, dataTest.coords, 0);
    metricGk(1, month) = getMetric(errorGk);
    rateGk(1, month) = fsrGk;

    disp(month);
end


% 绘制定位误差对比图
figure('PaperUnits','centimeters','PaperSize',[40,20],'PaperPosition',[0 0 40 20]); hold on;
plot(monthRange, metricRand, 'Color', [1 0 1], 'LineWidth', 2);
plot(monthRange, metricProb, 'Color', [0 1 1], 'LineWidth', 2);
plot(monthRange, metricNn, 'Color', [0 1 0], 'LineWidth', 2);
plot(monthRange, metricKnn, 'Color', [1 0 0], 'LineWidth', 2);
plot(monthRange, metricStg, 'Color', [0 0 1], 'LineWidth', 2);
plot(monthRange, metricGk, 'Color', [0 0 0], 'LineWidth', 2); hold off;
legend({'Rand','Prob','NN', 'kNN', 'Stg', 'Gk'},'fontsize',16,'Location','eastoutside');
axis([1,monthAmount,0,6]);
xticks((1:1:monthAmount));
xlabel('month number','fontsize',16);
ylabel('75 percentile error (m)','fontsize',16);
grid on;

% 计算75%定位误差
function [metric] = getMetric(errors)
    metric = prctile(errors, 75);
end
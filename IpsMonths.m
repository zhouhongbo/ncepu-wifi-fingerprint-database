% Script to generate the paper's figures "ipsError"

close all; % 删除其句柄未隐藏的所有图窗

addpath('db','files','ids','ips'); % 向搜索路径中添加文件夹

% For reproducibilty in the random method
rng('default'); % 会生成相同的随机数

% Common to all methods
monthAmount = 2; % month看作week
notDetected = 100;
monthRange = (1:monthAmount);

% Storage for 2D error
metricRand = zeros(1, monthAmount);
metricProb = zeros(1, monthAmount);
metricNn = zeros(1, monthAmount);
metricKnn = zeros(1, monthAmount);
metricStg = zeros(1, monthAmount);
metricGk = zeros(1, monthAmount);

% Storage for floor detection rate
rateRand = zeros(1, monthAmount);
rateProb = zeros(1, monthAmount);
rateNn = zeros(1, monthAmount);
rateKnn = zeros(1, monthAmount);
rateStg = zeros(1, monthAmount);
rateGk = zeros(1, monthAmount);

for month = monthRange
    % load current month data
    dataTrain = loadContentSpecific('db', 1, [2, 4], month); % 用晚上的数据
    dataTest = loadContentSpecific('db', 2, [2, 4, 6, 8], month); % 用晚上的数据
    
    % deal with not seen AP
    dataTrain.rss(dataTrain.rss==100) = -105;
    dataTest.rss(dataTest.rss==100) = -105;
    
    % random location estimation
    kAmount = 1;    % Single Point
    [predictionRandom] = randomEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, kAmount);
    [errorRandom,fsrR] = customError(predictionRandom, dataTest.coords, 0);
    metricRand(1, month) = getMetric(errorRandom);
    rateRand(1, month) = fsrR;
    
    % Probabilistic method estimation
    kValue = 1;    % Single Point
    [predictionProb] = probEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, kValue, floor(dataTrain.ids./100));
    [errorProb,fsrP] = customError(predictionProb, dataTest.coords, 0);
    metricProb(1, month) = getMetric(errorProb);
    rateProb(1, month) = fsrP;
    
    % Nn method estimation
    knnValue = 1;    % Number of neighbors
    predictionNn = kNNEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, knnValue);
    [errorNn,fsrK] = customError(predictionNn, dataTest.coords, 0);
    metricNn(1, month) = getMetric(errorNn);
    rateNn(1, month) = fsrK;
    
    % kNN method estimation
    knnValue = 9;    % Number of neighbors
    predictionKnn = kNNEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, knnValue);
    [errorKnn,fsrK] = customError(predictionKnn, dataTest.coords, 0);
    metricKnn(1, month) = getMetric(errorKnn);
    rateKnn(1, month) = fsrK;
    
    % Stg method estimation
    stgValue = 3;    % AP filtering value
    kValue = 5;    % Number of neighbors
    predictionStg = stgKNNEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, stgValue, kValue);
    [errorStg,fsrS] = customError(predictionStg, dataTest.coords, 0);
    metricStg(month) = getMetric(errorStg);
    rateStg(1, month) = fsrS;
    
    % Gk method estimation
    std_dB = 4; % (has almost no effect in this scenario)
    kValue = 12;
    predictionGk = gaussiankernelEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, std_dB, kValue);
    [errorGk,fsrGk] = customError(predictionGk, dataTest.coords, 0);
    metricGk(1, month) = getMetric(errorGk);
    rateGk(1, month) = fsrGk;

    disp(month);
end


% Display figure "ipsError"
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
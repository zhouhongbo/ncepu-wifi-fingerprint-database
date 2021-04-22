close all; % 删除其句柄未隐藏的所有图窗

addpath('db','files','ids','ips'); % 向搜索路径中添加文件夹

% 所有定位算法通用的变量
monthAmount = 3; % month看作week
notDetected = 100;
monthRange = (1:monthAmount);

% 保存75%定位误差的变量
metricProb = zeros(1, monthAmount);
metricNn = zeros(1, monthAmount);
metricKnn = zeros(1, monthAmount);
metricStg = zeros(1, monthAmount);
metricGk = zeros(1, monthAmount);

% 保存楼层判断成功率的变量
rateProb = zeros(1, monthAmount);
rateNn = zeros(1, monthAmount);
rateKnn = zeros(1, monthAmount);
rateStg = zeros(1, monthAmount);
rateGk = zeros(1, monthAmount);

for month = monthRange
    % 加载本周数据
    dataTrain = loadContentSpecific('db', 1, [2, 4], month); % 用晚上的数据
    dataTest = loadContentSpecific('db', 2, [2, 4, 6, 8], month); % 用晚上的数据
    
    % 减少一半训练集数据
    id = mod(dataTrain.ids, 10) >= 5;
    dataTrain.rss(id, :) = [];
    dataTrain.coords(id, :) = [];
    dataTrain.time(id, :) = [];
    dataTrain.ids(id, :) = [];
    
    % 处理无信号AP的数据
    dataTrain.rss(dataTrain.rss==100) = -105;
    dataTest.rss(dataTest.rss==100) = -105;
    
    % Prob方法
    kValue = 1;    % 选取概率最大节点的个数
    [predictionProb] = probEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, kValue, floor(dataTrain.ids./100));
    [errorProb,fsrP] = customError(predictionProb, dataTest.coords, 0);
    metricProb(1, month) = getMetric(errorProb);
    rateProb(1, month) = fsrP;
    
    disp('Prob:')
    disp(['平均误差：', num2str(mean(errorProb))])
    disp(['68%概率误差：', num2str(prctile(errorProb, 68))])
    disp(['75%概率误差：', num2str(prctile(errorProb, 75))])
    disp(['95%概率误差：', num2str(prctile(errorProb, 95))])
    disp(['误差标准差：', num2str(std(errorProb))])
    disp(['1m概率：', num2str(sum(errorProb <= 1)/ size(errorProb, 1))])
    disp(['2m概率：', num2str(sum(errorProb <= 2)/ size(errorProb, 1))])
    disp(['3m概率：', num2str(sum(errorProb <= 3)/ size(errorProb, 1))])
    
    % NN方法
    knnValue = 1;    % 选取的邻居节点个数
    predictionNn = kNNEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, knnValue);
    [errorNn,fsrK] = customError(predictionNn, dataTest.coords, 0);
    metricNn(1, month) = getMetric(errorNn);
    rateNn(1, month) = fsrK;
    
    disp('NN：');
    disp(['平均误差：', num2str(mean(errorNn))])
    disp(['68%概率误差：', num2str(prctile(errorNn, 68))])
    disp(['75%概率误差：', num2str(prctile(errorNn, 75))])
    disp(['95%概率误差：', num2str(prctile(errorNn, 95))])
    disp(['误差标准差：', num2str(std(errorNn))])
    disp(['1m概率：', num2str(sum(errorNn <= 1)/ size(errorNn, 1))])
    disp(['2m概率：', num2str(sum(errorNn <= 2)/ size(errorNn, 1))])
    disp(['3m概率：', num2str(sum(errorNn <= 3)/ size(errorNn, 1))])
    
    % KNN方法
    knnValue = 5;    % 选取的邻居节点个数
    predictionKnn = kNNEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, knnValue);
    [errorKnn,fsrK] = customError(predictionKnn, dataTest.coords, 0);
    metricKnn(1, month) = getMetric(errorKnn);
    rateKnn(1, month) = fsrK;
    
    disp('KNN:')
    disp(['平均误差：', num2str(mean(errorKnn))])
    disp(['68%概率误差：', num2str(prctile(errorKnn, 68))])
    disp(['75%概率误差：', num2str(prctile(errorKnn, 75))])
    disp(['95%概率误差：', num2str(prctile(errorKnn, 95))])
    disp(['误差标准差：', num2str(std(errorKnn))])
    disp(['1m概率：', num2str(sum(errorKnn <= 1)/ size(errorKnn, 1))])
    disp(['2m概率：', num2str(sum(errorKnn <= 2)/ size(errorKnn, 1))])
    disp(['3m概率：', num2str(sum(errorKnn <= 3)/ size(errorKnn, 1))])
    
    % Stg方法
    stgValue = 3;    % 信号最强AP的个数
    kValue = 5;    % 选取的邻居节点个数
    predictionStg = stgKNNEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, stgValue, kValue);
    [errorStg,fsrS] = customError(predictionStg, dataTest.coords, 0);
    metricStg(month) = getMetric(errorStg);
    rateStg(1, month) = fsrS;
    
    disp('Stg:')
    disp(['平均误差：', num2str(mean(errorStg))])
    disp(['68%概率误差：', num2str(prctile(errorStg, 68))])
    disp(['75%概率误差：', num2str(prctile(errorStg, 75))])
    disp(['95%概率误差：', num2str(prctile(errorStg, 95))])
    disp(['误差标准差：', num2str(std(errorStg))])
    disp(['1m概率：', num2str(sum(errorStg <= 1)/ size(errorStg, 1))])
    disp(['2m概率：', num2str(sum(errorStg <= 2)/ size(errorStg, 1))])
    disp(['3m概率：', num2str(sum(errorStg <= 3)/ size(errorStg, 1))])
    
    % Gk方法
    std_dB = 4; % 此参数影响不大
    kValue = 12;
    predictionGk = gaussiankernelEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, std_dB, kValue);
    [errorGk,fsrGk] = customError(predictionGk, dataTest.coords, 0);
    metricGk(1, month) = getMetric(errorGk);
    rateGk(1, month) = fsrGk;
    
    disp('GK:')
    disp(['平均误差：', num2str(mean(errorGk))])
    disp(['68%概率误差：', num2str(prctile(errorGk, 68))])
    disp(['75%概率误差：', num2str(prctile(errorGk, 75))])
    disp(['95%概率误差：', num2str(prctile(errorGk, 95))])
    disp(['误差标准差：', num2str(std(errorGk))])
    disp(['1m概率：', num2str(sum(errorGk <= 1)/ size(errorGk, 1))])
    disp(['2m概率：', num2str(sum(errorGk <= 2)/ size(errorGk, 1))])
    disp(['3m概率：', num2str(sum(errorGk <= 3)/ size(errorGk, 1))])

    disp(month);
end


% 绘制定位误差对比图
figure('PaperUnits','centimeters','PaperSize',[40,20],'PaperPosition',[0 0 40 20]); hold on;
plot(monthRange, metricProb, 'Color', [0 1 1], 'LineWidth', 2);
plot(monthRange, metricNn, 'Color', [0 1 0], 'LineWidth', 2);
plot(monthRange, metricKnn, 'Color', [1 0 0], 'LineWidth', 2);
plot(monthRange, metricStg, 'Color', [0 0 1], 'LineWidth', 2);
plot(monthRange, metricGk, 'Color', [0 0 0], 'LineWidth', 2); hold off;
legend({'Prob','NN', 'kNN', 'Stg', 'Gk'},'fontsize',16,'Location','eastoutside');
axis([1,monthAmount,0,6]);
xticks((1:1:monthAmount));
xlabel('month number','fontsize',16);
ylabel('75 percentile error (m)','fontsize',16);
grid on;

% 计算75%定位误差
function [metric] = getMetric(errors)
    metric = prctile(errors, 75);
end
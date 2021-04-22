close all; % 删除其句柄未隐藏的所有图窗

addpath('db','files','ids','ips'); % 向搜索路径中添加文件夹

% 所有定位算法通用的变量
monthAmount = 6; % month看作week
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
    dataTrain = loadContentSpecific('db', 1, [2, 4], 1); % 用晚上的数据
    dataTest = loadContentSpecific('db', 2, [2, 4, 6, 8], month); % 用晚上的数据
    
    % 处理无信号AP的数据
    dataTrain.rss(dataTrain.rss==100) = -105;
    dataTest.rss(dataTest.rss==100) = -105;
    
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

    disp(month);
end


% 绘制定位误差对比图
figure; hold on;
plot(monthRange, metricKnn, ':');
plot(monthRange, metricStg, '--');
plot(monthRange, metricGk); hold off;
legend({'KNN', 'Stg', 'GK'});
axis([1,monthAmount,0,6]);
xticks((1:1:monthAmount));
xlabel('周次');
ylabel('75%概率误差/m');
grid on;
set(gca, 'fontsize', 10.5, 'fontname', '宋体');
box off

% 计算75%定位误差
function [metric] = getMetric(errors)
    metric = prctile(errors, 75);
end
% Copyright © 2017 Universitat Jaume I (UJI)
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of
% this software and associated documentation files (the “Software”), to deal in
% the Software without restriction, including without limitation the rights to
% use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
% of the Software, and to permit persons to whom the Software is furnished to do
% so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

% Script to generate the paper's figure "KnnReplacement" and "KnnAddition"

close all;

addpath('db','files','ids','ips');

mounthAmount = 15;
notDetected = 100;

monthRange = (1:mounthAmount);

% Metric for Replacement Strategy
metricValuesAllRep = zeros(1, mounthAmount);
metricValuesLocsRep = zeros(1, mounthAmount);
metricValuesPointsRep = zeros(1, mounthAmount);

% Metric for Addition Strategy
metricValuesAllAdd = zeros(1, mounthAmount);
metricValuesLocsAdd = zeros(1, mounthAmount);
metricValuesPointsAdd = zeros(1, mounthAmount);

% Storage for Addition Strategy
cumulDataTrain = struct('rss',[],'coords',[],'time',[],'ids',[]);

for month = monthRange
    % load current month data
    monthDataTrain = loadContentSpecific('db', 1, 1, month);
    dataTest = loadContentSpecific('db', 2, [1,2,3,4,5], month);
    
    % deal with not seen AP
    monthDataTrain.rss(monthDataTrain.rss==100) = -105;
    dataTest.rss(dataTest.rss==100) = -105;
    
    % Compute metric for the 3 alternatives using replacement strategy
    [monthValuesAll,monthValuesLocs,monthValuesPoints] = getEstimations(monthDataTrain, dataTest);
    metricValuesAllRep(1, month) = monthValuesAll;
    metricValuesLocsRep(1, month) = monthValuesLocs;
    metricValuesPointsRep(1, month) = monthValuesPoints;
    
    % Add current month training data to that of previous months
    cumulDataTrain.rss = [cumulDataTrain.rss;monthDataTrain.rss];
    cumulDataTrain.coords = [cumulDataTrain.coords;monthDataTrain.coords];
    cumulDataTrain.time = [cumulDataTrain.time;monthDataTrain.time];
    cumulDataTrain.ids = [cumulDataTrain.ids;monthDataTrain.ids];
    
    % Compute metric for the 3 alternatives using replacement strategy
    [monthValuesAll,monthValuesLocs,monthValuesPoints] = getEstimations(cumulDataTrain, dataTest);
    metricValuesAllAdd(1, month) = monthValuesAll;
    metricValuesLocsAdd(1, month) = monthValuesLocs;
    metricValuesPointsAdd(1, month) = monthValuesPoints;

    disp(month);
end

% Figure for replacement
createPlot(monthRange, metricValuesAllRep, metricValuesLocsRep, metricValuesPointsRep);
% Figure for addition
createPlot(monthRange, metricValuesAllAdd, metricValuesLocsAdd, metricValuesPointsAdd);


% Utility Functions

function [metricValuesAll,metricValuesLocs,metricValuesPoints] = getEstimations(dataTrain, dataTest)
    
    % kNN using all samples (no averaging)
    knnValue = 9;    
    prediction = kNNEstimation(dataTrain.rss, dataTest.rss, dataTrain.coords, knnValue);
    error = customError(prediction, dataTest.coords);
    metricValuesAll = getMetric(error);
    
    % kNN using average of 12 samples per location (both directions)
    knnValue = 6;
    [M, ~, pos] = getMeanAndStd(dataTrain.rss, dataTrain.coords);
    prediction = kNNEstimation(M, dataTest.rss, pos, knnValue);
    error = customError(prediction, dataTest.coords);
    metricValuesLocs = getMetric(error);
    
    % kNN using average of 6 samples per point (single direction)
    knnValue = 3;
    [M, ~, pos] = getMeanAndStd(dataTrain.rss, dataTrain.coords, floor(dataTrain.ids./100));
    prediction = kNNEstimation(M, dataTest.rss, pos, knnValue);
    error = customError(prediction, dataTest.coords);
    metricValuesPoints = getMetric(error);
end



function createPlot(monthRange, metricValuesAll, metricValuesLocs, metricValuesPoints)
    figure('PaperUnits','centimeters','PaperSize',[35,20],'PaperPosition',[0 0 35 20]); hold on;
    plot(monthRange, metricValuesAll, 'Color', [1 0 0], 'LineWidth', 4, 'LineStyle', '--');
    plot(monthRange, metricValuesLocs, 'Color', [0 1 0], 'LineWidth', 4, 'LineStyle', ':');
    plot(monthRange, metricValuesPoints, 'Color', [0 0 1], 'LineWidth', 4, 'LineStyle', '-.'); hold off;
    legend({'Without averaging','Single Direction Mean','Both Directions Mean'},'fontsize',16,'Location','southeast');
    axis([1,length(monthRange),0,5]);
    xlabel('month number');
    ylabel('75 percentile error (m)');
    xticks((1:1:length(monthRange)));
    grid on;
end

function [metric] = getMetric(errors)
    metric = prctile(errors, 75);
end
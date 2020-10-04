% Script to generate the paper's figures "Sample1Scatter" and "Sample6Scatter"
% as well as data for table "rssDiffSamples".

close all;

addpath('db','files','ids','ips','shelves');

% Load test datasets from month 15 
data123 = loadContentSpecific('db', 2, [1,2,3], 15);
data4 = loadContentSpecific('db', 2, [4], 15);

% Load 3rd floor, only one direction

inds123 = findPointsInRage(data123.ids, 1, 24);
inds4 = findPointsInRage(data4.ids, 1, 34);

chosenAP = 7;

data = struct;
data.rss = [data123.rss(inds123,chosenAP);data4.rss(inds4,chosenAP)];
data.coords = [data123.coords(inds123,:);data4.coords(inds4,:)];
data.time = [data123.time(inds123,:);data4.time(inds4,:)];
data.ids = [data123.ids(inds123,:);data4.ids(inds4,:)];

data.rss(data.rss==100) = nan;

% Visualization
for sNumber = [1,6]
    inds = findSample(data.ids, sNumber);
    
	figure('PaperUnits','centimeters','PaperSize',[20,20],'PaperPosition',[0 0 20 20]);
    scatter(data.coords(inds,1),data.coords(inds,2),[],data.rss(inds,:), 'filled', 'MarkerEdgeColor', 'k');
    caxis([-110, -40]);
    
    xlabel('x');
    ylabel('y');
    cbh = colorbar;
    ylabel(cbh, 'dBm');
    colormap(jet);
    axis square;
    
    
    hold on;
    nanVInd = isnan(data.rss);
    scatter(data.coords(inds&nanVInd,1),data.coords(inds&nanVInd,2),[],data.rss(inds&nanVInd,:), 'filled', 'MarkerFaceColor', 'k');
end


% RSS Difference for pais of consecutive sample, for table "rssDiffSamples"
inds = findSample(data.ids, 1);
prevRss = data.rss(inds,:);

rssDiff = zeros(1,5);
for sNumber = (2:6)
    inds = findSample(data.ids, sNumber);
    currRss = data.rss(inds,:);
    rssDiff(1,sNumber-1) = mean(abs(currRss-prevRss),'omitnan');
    prevRss = currRss;
end

round(rssDiff,2)


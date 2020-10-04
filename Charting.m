% Script to generate the paper's figure "Charting3rd" and "Charting5th"

close all;

addpath('db','files','ids','ips');

apNumber = 7;
barWidth = 0.25;

data = loadContentSpecific('db', 1, 1, 15);
data.rss(data.rss==100) = nan;

[M, S, pos] = getMeanAndStd(data.rss(:,apNumber),data.coords); % 12 samples considered per location

thirdFloorInds = pos(:,3) == 3;
drawRssBars(pos(thirdFloorInds,1), pos(thirdFloorInds,2), barWidth, M(thirdFloorInds,:), S(thirdFloorInds,:), '3rd Floor');

fifthFloorInds = pos(:,3) == 5;
drawRssBars(pos(fifthFloorInds,1), pos(fifthFloorInds,2), barWidth, M(fifthFloorInds,:), S(fifthFloorInds,:), '5th Floor');

% Script to generate the paper's figure "CollectionTimes"

close all;

addpath('db','files','ids','ips','shelves');

data = loadAllContent('db');

times = convertToTimeVectors(data.time);
trainingIds = findTrainOrTest(data.ids, 1);

yearMonthsDates = datetime({'Jun-2016', 'Jul-2016', 'Aug-2016', 'Sep-2016', 'Oct-2016', 'Nov-2016', 'Dec-2016', 'Jan-2017', 'Feb-2017', 'Mar-2017', 'Apr-2017', 'May-2017', 'Jun-2017', 'Jul-2017', 'Aug-2017', 'Sep-2017'},'InputFormat','MM-yy');

figure('PaperUnits','centimeters','PaperSize',[60,20],'PaperPosition',[0 0 60 20]);

for i = (1:15)
    hold on;
    % draw month training and test set's ocurrences
    monthInds = findMonth(data.ids,i);
    if (rem(i,2)>0) % to alternate colors
        color = [255/255 0/255 0/255];
    else
        color = [0/255 0/255 255/255];
    end
    scatter(datetime(times(monthInds,:)), trainingIds(monthInds), 100,'o', 'filled', 'MarkerFaceColor', color);
    
    % Draw month extent line
    minD = min(datetime(times(monthInds,:)));
    maxD = max(datetime(times(monthInds,:)));
    hold on;
    plot([minD;maxD], [4;4], 'Color', color, 'LineWidth', 3);
    text(mean([minD;maxD]),4.1,num2str(i,'%02.f'),'FontSize',20, 'HorizontalAlignment', 'center');
end

ylim([-1 5]);
set(gca,'YTick',[-1,0,1,3,4],'YTickLabel',{'','Test Sets','Training Sets','Month Extent',''},'fontsize',32);
xticks(yearMonthsDates);
xtickformat('yy-MM-dd');
xlabel('Collection Time','fontsize',32);
xtickangle(90);

% Draw year month division lines
for month = yearMonthsDates
    hold on;
    plot(repmat(month, 2,1), [-1;5], 'k');
end
hold off;

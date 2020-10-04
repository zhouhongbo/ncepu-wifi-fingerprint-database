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

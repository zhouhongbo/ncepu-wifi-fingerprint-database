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

% Script to generate the paper's table "APpresenceMonth1"

close all;

addpath('db','files','ids','ips');

dsAmount = 15;
notDetected = 100;

days = zeros(1, dsAmount);

% Get the data indicate which AP was seen each day
presenceData = [];
for number = (1:dsAmount)
    data = loadContentSpecific('db', 1, number, 1);  % Load the trn month data
    detected = (data.rss~=notDetected); % 1-> AP was detected, 0 otherwise
    atLeastOne = any(detected,1); % per column, 1-> AP was seen at least in 1 fingerprint
    presenceData = [presenceData;atLeastOne];
    
    times = convertToTimeVectors(data.time);
    days(number) = times(1,3);
end

% Get not the day of the month, but difference to the first day
daysDiff = days - min(days);

apsAmount = size(data.rss,2);
appearSummary = zeros(dsAmount, apsAmount);

% State machine for AP presence state determination
for ap = (1:apsAmount)
    lastState = 0;
    for number = (1:dsAmount)
        value = presenceData(number, ap);
        if (lastState == 0)
            if(value == 1)
                appearSummary(number, ap) = 1;
                lastState = 1;
            end
        elseif (lastState == 1)
            if(value == 1)
                appearSummary(number, ap) = 11;
                lastState = 11;
            else
                appearSummary(number, ap) = -2;
                lastState = -2;
            end
        elseif (lastState == 11)
            if(value == 0)
                appearSummary(number, ap) = -2;
                lastState = -2;
            else
                appearSummary(number, ap) = 11;
            end
        elseif (lastState == -2)
            if(value == 1)
                appearSummary(number, ap) = 3;
                lastState = 3;
            else
                appearSummary(number, ap) = -22;
                lastState = -22;
            end
        elseif (lastState == -22)
            if(value == 1)
                appearSummary(number, ap) = 3;
                lastState = 3;
            else
                appearSummary(number, ap) = -22;
            end
        elseif (lastState == 3)
            if(value == 1)
                appearSummary(number, ap) = 33;
                lastState = 33;
            else
                appearSummary(number, ap) = -4;
                lastState = -4;
            end
        elseif (lastState == 33)
            if(value == 1)
                appearSummary(number, ap) = 33;
            else
                appearSummary(number, ap) = -4;
                lastState = -4;
            end
        elseif (lastState == -4)
            if(value == 1)
                appearSummary(number, ap) = 3;
                lastState = 3;
            else
                appearSummary(number, ap) = -22;
                lastState = -22;
            end
        end
    end
end


% Give meaning to states
summary = struct('total', {}, 'new', {}, 'gone', {}, 'reapp', {}, 'regone', {}, 'all', {});
summary(dsAmount).total = 0;

for number = (1:dsAmount)
    summary(number).total = sum(appearSummary(number,:)>0);
    summary(number).new = sum(appearSummary(number,:)==1);
    summary(number).gone = sum(appearSummary(number,:)==-2);
    summary(number).reapp = sum(appearSummary(number,:)==3);
    summary(number).regone = sum(appearSummary(number,:)==-4);
    summary(number).all = sum(appearSummary(number,:)~=0);
    summary(number).day = daysDiff(number);
end

% Output to shell
struct2table(summary)
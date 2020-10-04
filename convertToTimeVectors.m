function [times] = convertToTimeVectors(timeNumbers)
% 修改：以前的输入参数示例20160603111129096，现在的输入参数示例20200926142506，函数输出不变
%convertToTimeVectors  Convert time values in the database format to the 
%   six-valued format used by matlab. The (yyyymmddhhmmsss), indicating y
%   digits for year, m for month, d for day, h for hour, m for minutes and
%   s for milliseconds.
    secs = rem(timeNumbers, 10^2); % r = rem(a,b) 返回 a 除以 b 后的余数
    mins = rem(floor(timeNumbers./10^2), 10^2);
    hors = rem(floor(timeNumbers./10^4), 10^2);
    days = rem(floor(timeNumbers./10^6), 10^2);
    mths = rem(floor(timeNumbers./10^8), 10^2);
    year = floor(timeNumbers./10^10);
    times = [year, mths, days, hors, mins, secs];
end
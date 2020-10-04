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

function [times] = convertToTimeVectors(timeNumbers)
%convertToTimeVectors  Convert time values in the database format to the 
%   six-valued format used by matlab. The (yyyymmddhhmmsss), indicating y
%   digits for year, m for month, d for day, h for hour, m for minutes and
%   s for milliseconds.
    secs = rem(floor(timeNumbers./10^3), 10^2);
    mins = rem(floor(timeNumbers./10^5), 10^2);
    hors = rem(floor(timeNumbers./10^7), 10^2);
    days = rem(floor(timeNumbers./10^9), 10^2);
    mths = rem(floor(timeNumbers./10^11), 10^2);
    year = floor(timeNumbers./10^13);
    times = [year, mths, days, hors, mins, secs];
end
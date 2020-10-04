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
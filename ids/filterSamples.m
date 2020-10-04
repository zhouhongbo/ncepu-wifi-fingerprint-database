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

function [result] = filterSamples(pointIds, sampleNumber, pointNumber, trainOrTest, campNumber, month)
% filter  From the list of ids pointIds, return the ids of all samples
% that belong to datasets from the specified month, campaign number and test 
% or training, and whose point number and sample number matches the specified
% parameters. To leave one paramater unspecified, assign [] to it.
%
%   See also loadPointIds,findSample,findPoint,findTrainOrTest,findCampNumber,findMonth.
    result = true(size(pointIds));
    result = result & findSample(pointIds,sampleNumber);
    result = result & findPoint(pointIds,pointNumber);
    result = result & findTrainOrTest(pointIds, trainOrTest);
    result = result & findCampNumber(pointIds, campNumber);
    result = result & findMonth(pointIds, month);
end
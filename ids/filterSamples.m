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
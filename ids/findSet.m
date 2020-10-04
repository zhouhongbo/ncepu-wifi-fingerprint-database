function [result] = findSet(pointIds, trainOrTest, campNumber, month)
% findSet  From the list of ids pointIds, return the ids of all samples
% that belong to datasets from the specified month, campaign number and 
% test or training.
%
%   See also loadPointIds.
    result1 = findTrainOrTest(pointIds, trainOrTest);
    result2 = findCampNumber(pointIds, campNumber);
    result3 = findMonth(pointIds, month);
    result = result1&result2&result3;
end
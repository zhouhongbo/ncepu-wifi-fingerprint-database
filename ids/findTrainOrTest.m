function [result] = findTrainOrTest(pointIds, trainOrTest)
% findTrainOrTest  From the list of ids pointIds, return the ids of all
% samples that belong to training(trainOrTest==1) or test(trainOrTest==2).

%   See also loadPointIds.
    digits = rem(floor(pointIds./10^5), 10^1);
    result = digits == trainOrTest;
end
% 根据trainOrTest参数处理ID,1 for train， 2 for test, 0 for both
function [result] = findTrainOrTest(pointIds, trainOrTest)
    digits = rem(floor(pointIds./10^5), 10^1);
    result = digits == trainOrTest;
end
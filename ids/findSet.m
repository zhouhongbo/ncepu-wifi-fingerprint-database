% 根据trainOrTest, campNumber, week参数处理ID
function [result] = findSet(pointIds, trainOrTest, campNumber, month)
    result1 = findTrainOrTest(pointIds, trainOrTest);
    result2 = findCampNumber(pointIds, campNumber);
    result3 = findMonth(pointIds, month);
    result = result1&result2&result3;
end
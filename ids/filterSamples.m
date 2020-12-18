% 根据sampleNumber, pointNumber, trainOrTest, campNumber, week参数处理ID
function [result] = filterSamples(pointIds, sampleNumber, pointNumber, trainOrTest, campNumber, month)
    result = true(size(pointIds));
    result = result & findSample(pointIds,sampleNumber);
    result = result & findPoint(pointIds,pointNumber);
    result = result & findTrainOrTest(pointIds, trainOrTest);
    result = result & findCampNumber(pointIds, campNumber);
    result = result & findMonth(pointIds, month);
end
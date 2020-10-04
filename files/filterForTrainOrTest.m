function [result] = filterForTrainOrTest(dirAndFileNames, trainOrTest, defs)
% filterForTrainOrTest  Utility: Get files names from dirAndFileNames that
% match the trainOrTest vaue both(trainOrTest==0), just training(trainOrTest==1), 
% just test(trainOrTest==2)
%
%   See also getFileNameDefs.
    result = true(1, size(dirAndFileNames,1));
    if (trainOrTest == 1)
        result = contains(dirAndFileNames(:,2),defs.train)';
    elseif (trainOrTest == 2)
        result = contains(dirAndFileNames(:,2),defs.test)';
    end
end
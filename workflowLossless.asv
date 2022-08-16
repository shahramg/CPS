function [cpa, TravelPaths, ptChgs, totalIntraTravelDistance, totalInterTravelDistance, totalIntraFlights, totalInterFlights, colorChgs] = workflowLossless(numFiles, cubeCapacity, doReset)
silent = false;

TravelPaths={};
ptChgs={};
totalIntraTravelDistance=[];
totalInterTravelDistance=[];
totalIntraFlights=[];
totalInterFlights=[];
colorChgs={};

pathToCloudPointFiles='./RoseClip/';

cpa=inMemoryCP(pathToCloudPointFiles,numFiles);

% Use the grid of the first cloud point for the subsequent point clouds
% and compute travel paths
if numFiles > 1
    for i=2:numFiles
        [ TravelPaths{i-1}, colorChgs{i-1} ] = algPointChanges(cpa{i-1}, cpa{i}, false, false)
    end
end

try
    ptChgs = computePtChgs(numFiles, TravelPaths, colorChgs, cpa, silent);
catch
    outputT= ['computePtChgs failed in workflowLossless.m '];
    disp(outputT);
end

try
    faceC = computeFaceChgs(numFiles, cpa, false);
catch
    outputT= ['computeFaceChgs failed in workflowLossless.m '];
    disp(outputT);
end

numFaces = 0;
for hidx=1:size(faceC,2)
    numFaces = numFaces + size(faceC{hidx},1);
end

filename = strcat('./','losslessPLY_',string(numFiles),'.cps');
createWriteHeaderToFile(filename, numFiles, 24, size(ptChgs,2), numFaces, false);
appendVerticesToFile(filename, ptChgs, false)
appendFacesToFile(filename, faceC, false);
end
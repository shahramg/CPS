function [ ptChgs, colorChgs ] = algPointChanges(ptCld1, ptCld2, sanity, silent)
chgidx=0;
ptChgs={};

CCidx=0;
colorChgs={};

% Construct a hash map on the first point cloud,
% Probe with the second to identify the changes.

chaosf = 0.001;

hashMapOnLeadFrame = containers.Map('KeyType','char', 'ValueType','any');

leadVL = ptCld1.vertexList;
tgtDimension = 1; % Possible values are 1, 2, 3 for W, H, and D
for i=1:size( leadVL, 2 )
    a1 = leadVL( i );
    b1 = a1{1};
    % keys(i)=(multiplier1 * round(b1(1),6)) + (multiplier2 * round(b1(2),6)) + (multiplier3 *round(b1(3),6));
    %keys(i)=utilHashFunction(b1);
    %vals(i)=ptCld1.cubes(tgtCubeID).assignedVertices(i);
    hval=utilHashFunction(b1);
    hashMapOnLeadFrame(hval)=i;
end

derivedVL = ptCld2.vertexList;
colorChangedPoints = 0;
leadColor=[];
derColor=[];
numMovedPoints = 0;
moved = [];
numMovCol = 0;
movCol=[];
modPts=[];
numMissingPts=0;
missingPts=[];
for i=1:size( derivedVL, 2 )
    deriveda1 = derivedVL( i );
    derivedb1 = deriveda1{1};

    % probeKey = (multiplier1 * round(derivedb1(1),6) ) + (multiplier2 * round(derivedb1(2),6) ) + (multiplier3 * round(derivedb1(3),6) ) ;
    probeKey = utilHashFunction(derivedb1);

    if hashMapOnLeadFrame.isKey(probeKey)
        lV = hashMapOnLeadFrame(probeKey);
        leada1 = leadVL( lV );
        leadb1 = leada1{1};
        leadWidth = leadb1(1);
        leadHeight = leadb1(2);
        leadDepth = leadb1(3);

        %%%if leadWidth == derivedb1(1) && leadHeight == derivedb1(2) && leadDepth == derivedb1(3)
        if abs(leadWidth-derivedb1(1))<chaosf && abs(leadHeight-derivedb1(2))<chaosf && abs(leadDepth-derivedb1(3)) <chaosf
            % Point did not move
            % Check if color changed
            leadRed = leadb1(4);
            leadGreen = leadb1(5);
            leadBlue = leadb1(6);
            leadAlpha = leadb1(7);
            if leadRed == derivedb1(4) && leadGreen == derivedb1(5) && leadBlue == derivedb1(6) && leadAlpha == derivedb1(7)
            else
                colorChangedPoints = colorChangedPoints + 1;
                leadColor(colorChangedPoints)=lV;
                derColor(colorChangedPoints)=derivedVL(i);
            end
            remove(hashMapOnLeadFrame, probeKey); % Delete hashmap entry to find newly inserted points.
        end
    else
        numMissingPts=numMissingPts+1;
        missingPts(numMissingPts)=i;
    end
end
modPts=cell2mat( hashMapOnLeadFrame.values() );

%modPts contains a list of points in ptCld1 absent from ptCld2
%missingPts contains a list of points in ptCld2 missing from ptCld1
%We want to pair them up based on their index

if size(modPts,2) ~= size(missingPts,2)
    outputT= ['Error algPointChanges:  size of modPts ', num2str(size(modPts,2)),' does not match size of missingPts ', num2str(size(missingPts,2))];
    disp(outputT);
end

for i=1:size(modPts,2)
    chgidx=chgidx +1;
    srcPt=modPts(i);
    ptChgs{chgidx}=horzcat(1, srcPt, ptCld1.vertexList( srcPt ), 1, srcPt, ptCld2.vertexList( srcPt ) );
    % Remove srcPt from missingPts
    if any(missingPts(:)==srcPt) 
        % Remove element from missingPts
        missingPts=missingPts(missingPts~=srcPt);
    end
end

if size(missingPts,2) > 0
    outputT= ['Error algPointChanges:  size of missingPts ', num2str(size(modPts,2)),' is greater than zero.  This case is not handled and must be implemented. '];
    disp(outputT);
end

end
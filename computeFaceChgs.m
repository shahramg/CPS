function [faceChgs] = computeFaceChgs(numPtClds, PtCldArray, silent)
faceChgs = {};

% Identify faces that change from one point cloud to the next by:
% 1. Read faces of point cloud i into a hash table HT_i
% 2. Read faces of point cloud i+1 and probe HT_i
% 3. Everytime there is a match then increase the duration of point cloud i
% 4. If there is no match then go and check HT_i-1 until HTs are exhausted
% 5. If the face is found then extend its duration to i.
% 6. If the face is not found thn insert it in HT_i+1

% create a hash table on the first point cloud and populate it with faces
hashMapOnFirstCldPt = containers.Map('KeyType','char', 'ValueType','any');
srcCloudPoint = PtCldArray{1};
startTS = 0;
endTS = 1 * 1000/24;

% We use the backupVertexList because it is the original AND this code
% only reads coordinates of points without changing them.
for i=1:size( srcCloudPoint.faceList, 2 )
    hval=utilFaceHashFunction( srcCloudPoint.faceList(i), srcCloudPoint.backupVertexList );
    duration1 = durationClass(startTS);
    numVs = srcCloudPoint.faceList{i}(1);
    f1=faceElt(duration1);
    f1.setEndTS(endTS);
    for v=1:numVs
        vidx = srcCloudPoint.faceList{i}(v+1);
        f1.regVertex(srcCloudPoint.backupVertexList, vidx);
    end

    hashMapOnFirstCldPt(hval)=f1;
end

hashMapArrays={};
hashMapArrays{1}=hashMapOnFirstCldPt;

% Traverse the facelist of each point cloud and identify their duration
for ptcldidx=2:numPtClds
    if ~silent
        outputT= ['Processing face changes for point cloud ', num2str(ptcldidx-1), ' with ', num2str( size(PtCldArray{ptcldidx}.faceList,2) ), ' faces.' ];
        disp(outputT);
    end

    newHashMap = containers.Map('KeyType','char', 'ValueType','any');
    hashMapArrays{ptcldidx}=newHashMap;
    tgtFaceList = PtCldArray{ptcldidx}.faceList;
    tgtVertexList = PtCldArray{ptcldidx}.backupVertexList;

    % start time stamp for duration interval in milliseconds
    startTS = (ptcldidx-1) * 1000/24;
    endTS = (ptcldidx) * 1000/24;

    % Enumerate the flight paths for change of position
    for f=1:size(tgtFaceList,2)
        probeKey=utilFaceHashFunction( tgtFaceList(f), tgtVertexList );
        hashMapIdx=ptcldidx-1;
        foundProbeKey=false;
        for hidx=hashMapIdx:-1:1
            if foundProbeKey == false && hashMapArrays{hidx}.isKey(probeKey)
                % If found then change its end interval to the current startTS.
                % This end interval may change when processing the next point cloud.
                face1=hashMapArrays{hidx}(probeKey);
                face1.setEndTS(endTS);
                foundProbeKey = true;
            end
        end
        if ~foundProbeKey
            % Add this face to the new hash table with startTS as its
            % starting timestamp
            duration1 = durationClass(startTS);
            face1=faceElt(duration1);
            face1.setEndTS(endTS);

            for v=2:size(tgtFaceList{f},2)
                vidx = tgtFaceList{f}(v); %face1.vertices{v+1};
                face1.regVertex(tgtVertexList, vidx);
            end
            newHashMap(probeKey)=face1;
        end
    end
end
faceChgs=hashMapArrays;
end
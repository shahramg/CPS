classdef CloudPoint < handle
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Description:  This is the point cloud class.  A motion      %
    %   illumination consists of a sequence of instances of this  %
    %   class.                                                    %
    %                                                             %
    % Used by: inMemoryCP                                         %
    % Dependencies: oneCube class                                 %
    % Author: Shahram Ghandeharizadeh                             %
    % Date: July 4, 2022                                          %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        identity
        filename
        backupVertexList
        vertexList
        faceList
        minL
        maxL
        minH
        maxH
        minD
        maxD

        numVertices {mustBeInteger} = 0
    end

    methods
        function [hashtbl,dups] = remDups(obj,vtList)
            % Iterate the assigned vertices
            numDups = 0;
            dups=[];
            hashtbl = containers.Map('KeyType','char', 'ValueType','any');

            obj.numVertices=0;
            obj.vertexList={};

            for i=1:size(vtList,2)
                coord=vtList{i};
                tgtkey =  utilHashFunction(coord);
                %if any(hashset(:) == tgtkey)
                if hashtbl.isKey(tgtkey)
                    % Do nothing
                    numDups = numDups+1;
                    dups=[dups,i];
                    obj.numVertices = obj.numVertices + 1;

                    if mod(numDups, 3)==0
                        obj.maxL=obj.maxL+(0.01*numDups);
                        obj.vertexList{obj.numVertices}(1)=obj.maxL;
                    elseif mod(numDups, 3)==1
                        obj.maxH=obj.maxH+(0.01*numDups);
                        obj.vertexList{obj.numVertices}(2)=obj.maxH;
                    elseif mod(numDups, 3)==2
                        obj.maxD=obj.maxD+(0.01*numDups);
                        obj.vertexList{obj.numVertices}(3)=obj.maxD;
                    end

                    for idx=4:size(vtList{i},2)
                        obj.vertexList{obj.numVertices}(idx)=vtList{i}(idx);
                    end
                else
                    %newVertices(end+1)=pt;
                    %hashset(end+1)=tgtkey;
                    hashtbl(tgtkey)=i;
                    obj.numVertices = obj.numVertices + 1;
                    obj.vertexList{obj.numVertices}=vtList{i};
                end
            end
            outputT= sprintf('Replaced %d duplicates with a negative coordinate.',numDups);
            disp(outputT);
        end
        function obj = resetCloudPoint(obj,doReset,silent,cubeCapacity,llArray,hlArray,dlArray,inputCubes)
            %if obj.cubeCapacity ~= cubeCapacity
            % Verify the input cubes have the appropriate capacity
            if inputCubes ~= 0
                if cubeCapacity ~= inputCubes(1).maxVertices
                    error('Error in resetCloudPoint, specified cubeCapacity ',num2str(cubeCapacity) ,' does not match the inputCubes structure with capacity ',num2str(inputCubes(1).maxVertices) , '.')
                end
            end
            %end
            obj.createGrid(true,silent,cubeCapacity,llArray,hlArray,dlArray,inputCubes)
        end
        function obj = CloudPoint(id, filename, vtList, fList, minL, maxL, minH, maxH, minD, maxD)
            obj.identity=id;
            obj.filename=filename;
            obj.faceList={};
            obj.minL=minL;
            obj.maxL=maxL;
            obj.minH=minH;
            obj.maxH=maxH;
            obj.minD=minD;
            obj.maxD=maxD;
            %backupVertexList=zeros(size(vL));

            [hashtbl,dups]=obj.remDups(vtList); % populates vertexList and removes duplicates

            upperLimit = size(obj.vertexList,2);

            % Verify the faceList does not reference a duplicate vertex
            % 1. Scan faces and their vertices
            % 2. Check if a vertex appears in the dups list.
            % 3. If so then look it up in the hashtbl for its replacement
            % vertex.
            for f=1:size(fList,2)
                vArray = [];
                numVs = fList{f}(1);
                vArray = [vArray, numVs];
                vL = fList{f}(2:4);
                iS=intersect(vL,dups);
                if size(iS,2) > 0
                    for v=1:numVs
                        vidx = fList{f}(v+1);
                        tgtV = vtList{vidx};
                        tgtkey =  utilHashFunction(tgtV);
                        newVid = hashtbl(tgtkey);
                        vArray = [vArray, newVid];
                    end
                else
                    vArray = [vArray, fList{f}(2: size(fList{f},2) )];
                end
                obj.faceList{f}=vArray;
            end

            for i=1:size(obj.vertexList,2)
                obj.backupVertexList{i}=obj.vertexList{i};
            end
        end
    end
end
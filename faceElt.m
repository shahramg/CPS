classdef faceElt < handle
    properties
        coordElt = {}
        vertices = []
        dursElt = 0
        numvertices=0
        numPtClds {mustBeInteger} = 0
    end
    methods
        function output = setEndTS(obj,endTS)
            if endTS < obj.dursElt.startTS
                outputT= sprintf('Error in msgElt.setEndTS end of a duration %d is a value less than the start of the duration %d ', endTS, obj.dursElt.startTS);
                disp(outputT);
                error('Exiting, cannot continue.')
            end
            obj.dursElt.endTS = endTS;
        end
        function output = regVertex(obj, vertexList, vid)
            obj.numvertices = obj.numvertices+1;
            obj.vertices=[obj.vertices, vid];
            c=coordClass(vertexList{vid+1}(1), vertexList{vid+1}(2), vertexList{vid+1}(3));
            obj.coordElt{obj.numvertices}=c;
        end
        function obj = faceElt(durationInstance)
            obj.dursElt = durationInstance;
        end
    end
end
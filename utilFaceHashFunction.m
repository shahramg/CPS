function hval = utilFaceHashFunction(face, vertexList)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description:  A hash function for the coordinates of        %
%   points that constitute a face. Resulting hval is a string.%
%                                                             %
% Assumptions:  Point cloud files start with the string token %
%    'Scene' and end with the string token '.ply'             %
%                                                             %
% Used by: computeFaceChgs                                    %
% Dependencies: None                                          %
% Author: Shahram Ghandeharizadeh                             %
% Date: July 4, 2022                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numVs = face{1}(1);
finalkey = "";
for v=1:numVs
    vidx = face{1}(v+1);
    if vidx+1 > size(vertexList,2)
        outputT= sprintf('Index %d is out of range.  Max elements allowed is %d',vidx, size(vertexList,2));
        disp(outputT);
    end
    tgtV = vertexList{vidx+1};
    tgtkey =  utilHashFunction(tgtV);
    finalkey = strcat(finalkey,tgtkey);
end
hval=finalkey;
end
function output = appendFacesToFile(filename, arrayHashTbls, silent)
if ~silent
    outputT= ['writeFaceToFile filename=', num2str(filename)];
    disp(outputT);
end

fileID = fopen(filename,'a+');

numFaces = 0;
for hidx=1:size(arrayHashTbls,2)
    numFaces = numFaces + size(arrayHashTbls{hidx},1);
end

if ~silent
    outputT= ['Number of faces to write is =', num2str(numFaces)];
    disp(outputT);
end

cntr=0;
for hidx=1:size(arrayHashTbls,2)
    vals = arrayHashTbls{hidx}.values();
    for v=1:size(vals,2)
        face1=vals(v);
        numv=size(face1{1}.vertices, 2);
        fprintf(fileID,'%d ',numv);
        fprintf(fileID,'%d ',face1{1}.vertices);
        fprintf(fileID,'%d ',face1{1}.dursElt.startTS);
        fprintf(fileID,'%d\n',face1{1}.dursElt.endTS);
        cntr=cntr+1;
    end
end

if ~silent
    outputT= ['Wrote ', num2str(numFaces), ' number of faces.'];
    disp(outputT);
end

fclose(fileID);
end
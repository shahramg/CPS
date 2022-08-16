function output = appendVerticesToFile(filename, ptChgs, silent)
if ~silent
    outputT= ['writeFaceToFile filename=', num2str(filename)];
    disp(outputT);
end

fileID = fopen(filename,'a+');

numVs = size(ptChgs,2);

if ~silent
    outputT= ['Number of vertices to write is =', num2str(numVs)];
    disp(outputT);
end

hashMapOnPos = containers.Map('KeyType','int32', 'ValueType','any');
for v=1:numVs
    point1=ptChgs(v);
    id1=point1{1}.idx;
    %v
    hashMapOnPos(id1)=point1;
end

cntr=0;

for v=1:numVs
    point1=hashMapOnPos(v);
    %fprintf('%d ', v);
    szwip = [point1{1}.whatispresent];
    if size(szwip,2)==1
        fprintf(fileID,'%3.6f ',point1{1}.coordElt(1).length);
        fprintf(fileID,'%3.6f ',point1{1}.coordElt(1).height);
        fprintf(fileID,'%3.6f ',point1{1}.coordElt(1).depth);
        fprintf(fileID,'%d ', point1{1}.colorsElt.red);
        fprintf(fileID,'%d ', point1{1}.colorsElt.green);
        fprintf(fileID,'%d ', point1{1}.colorsElt.blue);
        fprintf(fileID,'%d ', point1{1}.colorsElt.transparency);
        fprintf(fileID,'%d ',point1{1}.dursElt.startTS);
        fprintf(fileID,'%d\n',point1{1}.dursElt.endTS);
    else
        %numelts = size(szwip,2);
        idxarr=[point1{1}.idx];
        for i=1:size(idxarr,2)
            if idxarr(i) ~= idxarr(1)
                outputT= ['Error, the index array has different values: ', num2str(idxarr)];
                disp(outputT);
            end
        end

        warr=[point1{1}.whatispresent];
        coordarr=[point1{1}.coordElt];
        colorarr=[point1{1}.colorsElt];
        durarr=[point1{1}.dursElt];
        for i=1:size(warr,2)
            if warr(i)=='B'
                if i~=1
                    fprintf(fileID,'B ');
                end
                fprintf(fileID,'%3.6f ',coordarr(i).length);
                fprintf(fileID,'%3.6f ',coordarr(i).height);
                fprintf(fileID,'%3.6f ',coordarr(i).depth);
                fprintf(fileID,'%d ', colorarr(i).red);
                fprintf(fileID,'%d ', colorarr(i).green);
                fprintf(fileID,'%d ', colorarr(i).blue);
                fprintf(fileID,'%d ', colorarr(i).transparency);
                fprintf(fileID,'%3.4f ',durarr(i).startTS);
                fprintf(fileID,'%3.4f',durarr(i).endTS);
                if i==size(warr,2)
                    fprintf(fileID,'\n');
                else
                    fprintf(fileID,' ');
                end
            elseif warr(i)=='D'
                fprintf(fileID,'D %3.6f ',coordarr(i).length);
                fprintf(fileID,'%3.6f ',coordarr(i).height);
                fprintf(fileID,'%3.6f ',coordarr(i).depth);
                fprintf(fileID,'%3.4f ',durarr(i).startTS);
                fprintf(fileID,'%3.4f',durarr(i).endTS);
                if i==size(warr,2)
                    fprintf(fileID,'\n');
                else
                    fprintf(fileID,' ');
                end
            elseif warr(i)=='C'
                outputT= ['Error, Change of color is not supported ', num2str(colorarr)];
                disp(outputT);
            end
        end
    end

    cntr=cntr+1;
end

fclose(fileID);
end
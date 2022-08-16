function output = createWriteHeaderToFile(filename, ptclds, ptcldsPerSec, vertices, faces, silent)
if ~silent
    outputT= ['Generating header for filename=', num2str(filename)];
    disp(outputT);
end

fileID = fopen(filename,'w');
fprintf(fileID,'Lossless compressed ply\n');
fprintf(fileID,'format ascii 1.0\n');
fprintf(fileID,'comment Created by DPCC 0.0.0 - https://viterbi.usc.edu/directory/faculty/Ghandeharizadeh/Shahram\n');
fprintf(fileID,'Point clouds %d\n',ptclds);
fprintf(fileID,'Point clouds per second %d\n',ptcldsPerSec);
fprintf(fileID,'element vertex %d\n',vertices);
fprintf(fileID,'property float x\n');
fprintf(fileID,'property float y\n');
fprintf(fileID,'property float z\n');
fprintf(fileID,'property uchar red\n');
fprintf(fileID,'property uchar green\n');
fprintf(fileID,'property uchar blue\n');
fprintf(fileID,'property uchar alpha\n');
fprintf(fileID,'element face %d\n',faces);
fprintf(fileID,'property list uchar uint vertex_indices\n');
fprintf(fileID,'end_header\n');

fclose(fileID);
end
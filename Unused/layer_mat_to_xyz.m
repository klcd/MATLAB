function [ ] = layer_mat_to_xyz( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

L = load('Layer_Matrix.dat');
types = {'Au','N','B'};

fid = fopen('Layer_Matrix.xyz','w');

fprintf(fid,'%f\n\n',length(L));

for ii=1:length(L)
    fprintf(fid,'%s\t%f\t%f\t%f\n',types{L(ii,4)},10*L(ii,1:3));
end
fclose(fid);

end


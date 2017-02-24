function [ ] = write_lattice_dat( load_path, save_path, file_name )
%WRITE_LATTICD_DAT Summary of this function goes here
%   Detailed explanation goes here

if exist('load_path','var')
    if exist('file_name','var')
        posid = fopen([load_path file_name]);
    else
        posid = fopen([load_path 'atom_position.xyz']);
    end
    vecid = fopen([load_path 'lattice_vectors.dat']);
else
    posid = fopen('atom_position.xyz');
    vecid = fopen('lattice_vectors.dat');
end
if exist('save_path','var')
    wid = fopen([save_path 'lattice_dat'],'w');
else
    wid = fopen('lattice_dat','w');
end

buff = fgetl(posid);
fprintf(wid,[buff ' 0 0 0 0\n\n']);
num_atom = sscanf(buff,'%d',1);
fgets(posid);

vecs = cell2mat(textscan(vecid,'%f%f%f'));
fclose(vecid);

pos = textscan(posid,'%s%f%f%f');
vecs(1,1) = ceil(pos{2}(end)+1);
fclose(posid);

for ii=1:3
    fprintf(wid,'%.6f\t%.6f\t%.6f\n',vecs(ii,:));
end
fprintf(wid,'\n');
for ii=1:num_atom
    fprintf(wid,'%s\t%.6f\t%.6f\t%.6f\n',pos{1}{ii},pos{2}(ii),pos{3}(ii),pos{4}(ii));
end

fclose(wid);

end


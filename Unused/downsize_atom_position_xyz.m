function [ ] = downsize_atomposition( remove_list,num_layer,rem_numbers,load_path, save_path )
%DOWNSIZE_ATOMPOSITION Removes the specified atoms from the
%atom_position.xyz-file
%   Removes the atoms in remove_list from the atom_position.xyz-file
%   remove_list: list of the index of the atoms to remove
%   path: path to the directory with the file, default: current directory

% Open the files
if exist('save_path','var')
    wid = fopen([save_path 'atom_position.xyz'],'w');
else
    wid = fopen('atom_position.xyz','w');
end
if exist('load_path','var')
    fid = fopen([load_path 'atom_position.xyz']);
else
    fid = fopen('atom_position.xyz');
end

if ~strcmp(load_path,save_path)
    copyfile([load_path 'lattice_vectors.dat'],[save_path 'lattice_vectors.dat']);
end
    
% The first line contains the number of atoms
num_atoms = sscanf(fgets(fid),'%d');
fgets(fid); % empty line

% generate a list of atoms to keep
remove_list = sort(remove_list);
keep_list = 1:num_atoms;
keep_list = keep_list(setdiff(keep_list,remove_list));
% read all 
data = textscan(fid,'%s %f %f %f',num_atoms);
% close the input file
fclose(fid);
% find the size of the chunk removed
d = data{2}(rem_numbers(2))-data{2}(rem_numbers(1));
d = abs(d/(num_layer+1)*num_layer);
% Move the atoms to fill the gap
data{2}(rem_numbers(2):end) = data{2}(rem_numbers(2):end)-d;
% Only keep the required data
for ii=1:length(data)
    data{ii} = data{ii}(keep_list);
end
% print the new number of atoms
fprintf(wid,'%d\n\n',num_atoms-length(remove_list));
% print the data to the new file. 
for ii =  1:num_atoms-length(remove_list)
    fprintf(wid,'%s\t%.6f\t%.6f\t%.6f\n',data{1}{ii},data{2}(ii)-data{2}(1),data{3}(ii),data{4}(ii));
end
% close the file
fclose(wid);
end
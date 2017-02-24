function [ ] = reduce_blocksize_smin( block_number, reduce_by, load_path, save_path )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

S = load([load_path 'Smin_dat']);
fid = fopen([save_path 'Smin_dat'],'w');

S(block_number+2:end) = S(block_number+2:end)-reduce_by;

fprintf(fid,'%d\n',S);
fclose(fid);

end


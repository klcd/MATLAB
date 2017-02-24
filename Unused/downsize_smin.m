function [ ] = downsize_smin( blocks, load_path, save_path )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

blocks = sort(blocks);

S = load([load_path 'Smin_dat']);
fid = fopen([save_path 'Smin_dat'],'w');

fprintf(fid,'%d\n',S(1)-length(blocks));

len = -S(blocks+1)+S(blocks+2);
if blocks(end) == S(1)
    % last block involved
    len(end) = len(end)+1;
end

n = zeros(1,S(1));
n(blocks) = len;

for bb=1:S(1)+1
    
    if ismember(bb,blocks)
        % remove the block
        S(bb+2:end) = S(bb+2:end) - n(bb);
    else
        fprintf(fid,'%d\n',S(bb+1));
    end
        
end

end


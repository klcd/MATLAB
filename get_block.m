function [ block ] = get_block(atom,sc)
% retrieve the block index of the atom (in which unit cell it is within the
% supercell)
block = floor((atom-1)/sc.uc.NA)+1;
end


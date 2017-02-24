function structure_param=reorder_atoms(structure_param,sc,ordering)
% Create an ordered list of atoms in the supercell, based on the atom lists
% defined in the unit cell. Atom indices in different blocks will be
% shifted by (block_index-1)*NA, where NA is the atoms number in the unit 
% cell, rendering the indices unique. The ordering is done by respect to
% the x, y, and z coordinates (in this sequence).


% Number of blocks

Nblocks=length(sc.block);

% loop over all the different regions of the device

for region=1:(structure_param.Nregions+1)
    
    % initialize the coordinates as NaN
    
    coords=NaN*ones(length(structure_param.atom_list{region})*Nblocks,3);
    
    % It will hold the inidices of the atoms in the supercell
    
    s=NaN(length(structure_param.atom_list{region})*Nblocks,1);
    
    % It will save the number of atoms to be retained in the supercell
    
    var_i=1;
    
    % loop over all the blocks (unit cells)
    
    for IB = 1:Nblocks
        
        % the vector pointing to this unit cell
        
        c=sc.block(IB).lat_vect*[sc.uc.axis(1).vect;sc.uc.axis(2).vect;sc.uc.axis(3).vect];
        
        % loop over all the atoms in the unit cell that are defined by the
        % structure_param.atom_list
        
        for IA = structure_param.atom_list{region}
            
            % check whether it is part of the supercell
            
            if (ismember(IA,sc.block(IB).atoms))
                
                % save the atoms coordinate in the supercell
                
                coords(var_i,:)=c+sc.uc.atom(IA).coord;
                
                % save the index of the atom in the supercell, that is the
                % index of the atom in the unit cell plus the block index
                % times the number of atoms per unit cell. E.g: the first
                % atom in the second unit cell is indexed as the number of
                % atoms in the unit cell plus 1.
                
                s(var_i)=IA+(IB-1)*sc.uc.NA;
                
                % count the atom
                
                var_i=var_i+1;
            end
        end
    end
    
    % sort the coordinates by x,y,z and save the new indices
    
    [~,ind] = sortrows(coords,ordering);
    
    % use this ordering for the atom indices
    
    structure_param.atom_list{region}=s(ind);
    
    % remove the empty entries
    
    structure_param.atom_list{region}=structure_param.atom_list{region}(~isnan(structure_param.atom_list{region}));
    
end

end
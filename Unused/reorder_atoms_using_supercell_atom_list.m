function structure_param=reorder_atoms_using_supercell_atom_list(structure_param,sc,ordering)
% Create an ordered list of atoms in the supercell, based on the atom lists
% defined in the supercell already. The ordering is done by respect to
% the x, y, and z coordinates (in this sequence).

for region=1:(structure_param.Nregions+1)
    
    coords=NaN*ones(length(structure_param.supercell_atom_list{region}),3);
    s=NaN*ones(length(structure_param.supercell_atom_list{region}),1);
    var_i=1;
    for IA = structure_param.supercell_atom_list{region}
        IB = get_block(IA,sc);
        c=sc.block(IB).lat_vect*[sc.uc.axis(1).vect;sc.uc.axis(2).vect;sc.uc.axis(3).vect];
        coords(var_i,:)=c+sc.uc.atom(mod(IA-1,sc.uc.NA)+1).coord;
        s(var_i)=IA;
        var_i=var_i+1;
    end
    
    [~,ind] = sortrows(coords,ordering);
    structure_param.atom_list{region}=s(ind);
    structure_param.atom_list{region}=structure_param.atom_list{region}(~isnan(structure_param.atom_list{region}));
    
end

end
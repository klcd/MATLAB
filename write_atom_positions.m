function write_atom_positions()
% write the atom positions in the device into a file called "atom_position.xyz"
% and into "lattice_dat" that contains the unit cell lattice vectors and
% atoms


% create again the supercell so that this function can be called
% independently from the Hamiltonian construction

uc_params=load_uc_params;
sc_params=load_sc_params;
structure_param = load_structure_params;

atom=find_centers(uc_params.unit_cell_vectors,uc_params.exclude_wfs);
if (isfield(sc_params,'corner'))
    sc = make_rectangular_supercell(atom,uc_params.unit_cell_vectors,sc_params.sc_vectors,sc_params.directions,0,sc_params.corner);
else
    sc = make_rectangular_supercell(atom,uc_params.unit_cell_vectors,sc_params.sc_vectors,sc_params.directions,sc_params.miny);
end
uc=sc.uc;

directions=sc_params.directions;
if (isfield(structure_param,'supercell_atom_list'))
    structure_param = reorder_atoms_using_supercell_atom_list(structure_param,sc,sc_params.directions);
else
    structure_param = reorder_atoms(structure_param,sc,sc_params.directions);
end

axes = uc.unit_cell_vectors;

% length of a supercell

L_cell = norm(sc.transport_axis.vect);

% initialize the number of supercells in the different regions

N_cell_i=zeros(1,structure_param.Nregions);

% count the atoms

atom_ind=0;

% loop over all the different device regions

for region=1:structure_param.Nregions
    
    % get the number of cells in this region
    
    N_cell_i(region)=round(structure_param.L(region)/L_cell);
    
    % get the actual atom_list
    
    atom_list=structure_param.atom_list{region};
    
    % Start from the first cell if this is the first region
    
    if (region ==1)
        leftcell=1;
        
    % otherwise consider the already placed cells
    
    else
        leftcell=sum(N_cell_i(1:(region-1)))+1;
    end
    
    % loop over the cells in this region
    
    for Ni_cell=leftcell:(leftcell+N_cell_i(region)-1)
        
        % loop over the atoms in this supercell
        
        for var_i = 1:length(atom_list)                   
            atom1 = atom_list(var_i);         
            
            % get the unit cell of this atoms
            
            block1 = get_block(atom1,sc);
            
            % get the index of this atom in the unit cell
            
            atom1 = mod(atom1-1,uc.NA)+1;        
            
            % coordinate of the atom in the device
            
            c=uc.atom(atom1).coord + sc.block(block1).lat_vect*axes + (Ni_cell-1)*sc.transport_axis.vect;
            
            % count the atoms
            
            atom_ind=atom_ind+1;
            
            % save the coordinate and atom type
            
            full_atom_list(atom_ind).coord=c;
            full_atom_list(atom_ind).type=uc.atom(atom1).type;
        end               
    end
end


% unit cell containing all the atoms

atom_list=structure_param.atom_list{structure_param.Nregions+1};

% save all the atom coordinates and types in one complete supercell to
% create lattice_dat

sc_atom_ind=0;
for var_i = 1:length(atom_list)                
    atom1 = atom_list(var_i);                
    block1 = get_block(atom1,sc);
    atom1 = mod(atom1-1,uc.NA)+1;        
    c=uc.atom(atom1).coord + sc.block(block1).lat_vect*axes;
    sc_atom_ind=sc_atom_ind+1;
    sc_atom_list(sc_atom_ind).coord=c;
    sc_atom_list(sc_atom_ind).type=uc.atom(atom1).type;
    
    % save the smallest x, y, and z coordinates
    
    if (var_i==1)
        minx=c(1);
        miny=c(2);
        minz=c(3);
    end
    if (c(1)< minx)
        minx=c(1);
    end
    if (c(2)< miny)
        miny=c(2);
    end
    if (c(3)< minz)
        minz=c(3);
    end    
end               

% minimum coordinates

mincoords = [minx, miny, minz];

% supercell vectors

X=sc.sc_abs_vectors;

% save the data into files

fid1 = fopen('atom_position.xyz', 'wt');
fid2 = fopen('lattice_dat', 'wt');
fprintf(fid1,int2str(length(full_atom_list)));
fprintf(fid2,[int2str(length(sc_atom_list)),' 0 0 0 0']);
fprintf(fid1,'\n\n');
fprintf(fid2,'\n\n');

for var_i=1:3
    fprintf(fid2,'%.6f\t%.6f\t%.6f\n',X(var_i,directions(1)),X(var_i,directions(2)),X(var_i,directions(3)));
end
fprintf(fid2,'\n');

for var_i = 1:length(full_atom_list)
    a=full_atom_list(var_i);
    fprintf(fid1,'%s\t%.6f\t%.6f\t%.6f\n',a.type,a.coord(directions(1))-mincoords(directions(1)),a.coord(directions(2))-mincoords(directions(2)),a.coord(directions(3))-mincoords(directions(3)));       
end   
for  var_i = 1:length(sc_atom_list)
    a=sc_atom_list(var_i);
    fprintf(fid2,'%s\t%.6f\t%.6f\t%.6f\n',a.type,a.coord(directions(1))-mincoords(directions(1)),a.coord(directions(2))-mincoords(directions(2)),a.coord(directions(3))-mincoords(directions(3)));    
end

fclose(fid1);
fclose(fid2);

end
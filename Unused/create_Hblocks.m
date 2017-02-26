function [Hblocks] = create_Hblocks(H123,sc,r_cut,NN_t,NN_p,NN_y,atom_list)

% retrieve the unit cell parameters

uc = sc.uc;

% count the Wannier functions, and create a list of them based on the order
% how the atoms appear in the atom_list (that is ordered by x,y,z).

Nwf = 0;
for var_i = 1:length(atom_list)
    atom = atom_list(var_i);
    
    % atoms are indexed such as the total number of atoms in a unit cell is
    % added to the index of the specific atom in the unit cell every time
    % when going to a next block (unit cell). E.g: if we have Mo S_1, S_2
    % with 1,2,3 indices in the unit cell, and the supercell consists of
    % two unit cell, the atom indices will be 1:3 in the first cell, and
    % 4:6 in the second cell.
    
    if (atom > uc.NA)                
        atom = mod(atom-1,uc.NA)+1;
    end
    wf_list((Nwf+1) : (Nwf+length(uc.atom(atom).wfs))) = uc.atom(atom).wfs;    
    Nwf = Nwf + length(uc.atom(atom).wfs);    
end

% retrieve the primitive unit cell vectors

axes = uc.unit_cell_vectors;

% initialize the Hblocks cell: first index refers to the transport
% direction, second index to the periodic direction. The center block
% will contain the interactions between atoms in the same supercell, the
% other blocks will contain the interactions between atoms in one cell and
% atoms in a neighbor cell (first second, etc. neighbor, + and - directions).

Hblocks = cell(2*NN_t+1,2*NN_p+1,2*NN_y+1);

% sizes of the Hamiltonian obtained from Wannier90

N1 = length(H123(:,1,1,1,1));
N2 = length(H123(1,:,1,1,1));
N3 = length(H123(1,1,:,1,1));

% middle indices

N10 = round((N1 + 1)/2);
N20 = round((N2 + 1)/2);
N30 = round((N3 + 1)/2);

% absolute value of the cutoff radius. Negative value meant 2D cutoff
% mode, positive 3D.

r_cut_abs = abs(r_cut);

% Loop through all the required neighbors in the transport direction

for It = (1:2*NN_t+1)
    
    % and in the periodic direction
    
    for Ip = (1:2*NN_p+1)
        
        for Iy = (1:2*NN_y+1)
            
        % initialize the Hamiltonian block
        
        H = zeros(Nwf,Nwf);
        
        % start counting the Wannier functions (first index)
        
        wf1_ind = 0;
        
        % loop through all the atoms in the supercell
        
        for var_i = 1:length(atom_list)
            atom1 = atom_list(var_i);
            
            % find out in which primitive unit cell (block) this atom is
            
            block1 = get_block(atom1,sc);
            
            % get the index of the atom within the primitive unit cell
            
            if (atom1 > uc.NA)
                atom1 = mod(atom1-1,uc.NA)+1;
            end
            
            % loop through all the Wannier functions centered on this atom.            
            
            for Iwf1 = 1:length(uc.atom(atom1).wfs)
                
                % index of the WF in the supercell
                
                wf1_ind = wf1_ind + 1;
                
                % index of the WF in the primitive unit cell
                
                wann_index_1 = wf_list(wf1_ind);
                                                
                % do the same loops for the second indices
                
                wf2_ind = 0;
                for var_j = 1:length(atom_list)
                    atom2 = atom_list(var_j);
                    block2 = get_block(atom2,sc);
                    if (atom2 > uc.NA)
                        atom2 = mod(atom2-1,uc.NA)+1;
                    end
                    for Iwf2 = 1:length(uc.atom(atom2).wfs)
                        wf2_ind = wf2_ind + 1;
                        wann_index_2 = wf_list(wf2_ind);
                        
                        % the distance between the atoms: the distance
                        % between the atoms within the unit cell, plus the
                        % difference in the unit cells plus the shift of
                        % the supercells (first, second, etc. neighbor)
                        
                        d = (uc.atom(atom1).coord + sc.block(block1).lat_vect*axes- uc.atom(atom2).coord - sc.block(block2).lat_vect*axes) + (NN_t+1-It)*sc.transport_axis.vect + (NN_p+1-Ip)*sc.periodic_axis.vect + (NN_y+1-Iy)*sc.confined_axis.vect;
                        
                        % 2D cutoff mode: project it onto the x-z plane
                        
                        if (r_cut<0)
                            r = sqrt(d([sc.axes(1) sc.axes(3)])*d([sc.axes(1) sc.axes(3)])');
                            
                        % 3D cutoff
                        
                        else
                            r = sqrt(d*d');
                        end
                        
                        % check whether the distance between the atoms is
                        % smaller than the cutoff radius
                        
                        if (r<r_cut_abs)
                            
                            % find out how much the unit cells of the two
                            % atoms are shifted compared to each other in
                            % terms of the primitive unit cell lattice
                            % vectors (atom2-atom1)
                            
                            shift_vect=-((NN_t+1-It)*sc.transport_axis.lat_vect + (NN_p+1-Ip)*sc.periodic_axis.lat_vect +(NN_y+1-Iy)*sc.confined_axis.lat_vect + sc.block(block1).lat_vect - sc.block(block2).lat_vect);
                            
                            % These are the unit cell indices of the
                            % Wannier90 output that we need. We just have
                            % to shift it with the indices of the home unit
                            % cell, since our indexing starts from 1, and
                            % the home unit cell indices are N10 N20 N30
                                                        
                            R_ind = round([N10 N20 N30] + shift_vect);
                            
                            % make sure the Hamiltonian actually contains
                            % this indices
                            
                            if (R_ind(1) >0 && R_ind(2) > 0 && R_ind(3) > 0 && R_ind(1)<N1+1 && R_ind(2)<N2+1 && R_ind(3)<N3+1)
                                
                                % select the appropriate matrix element
                                
                                H(wf1_ind,wf2_ind) = H123(R_ind(1),R_ind(2),R_ind(3),wann_index_1,wann_index_2);
                                
                            end
                        end
                    end
                end
            end
        end
        
        % save the matrix into the appropriate cell of Hblocks{}
        
        Hblocks{It,Ip,Iy} = H;
        end
    end
end


end
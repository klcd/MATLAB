function [ Ek,k,Hblocks_full ] = create_Hamiltonian(Hblocks_full)
% This function creates the Hamiltonian of the device defined in the
% load_structure_params.m, load_sc_params.m, and load_uc_params.m files.
% Hblocks_full contains all the interactions between the atoms in
% a supercell and another one within the defined interaction range. Ek will
% hold the eigenenergies at the corresponding k points if the band
% structure is calculated. Ek is a cell containing Nbands*Nkpts matrices, and
% k is a cell containing 3*Nkpts matrices with the x,y,z coordinates of the
% k points where the band structure is calulated, in terms of the supercell
% lattice vectors. The cell index is used to distinguish if the band
% structure is calculated at different parts of the device. Otherwise just
% refer to Ek{1} and k{1}.
% The Hblocks_full input argument is optional. Its role is to reuse the
% Hamiltonian blocks if only the length of a device is changed.
% The device Hamiltonians are saved to files. In case of a 2D material only
% H3, H4, and H5 are meaningful. They correspond to H-, H0, and H+


% load the data specific to this run from the load_*_params.m files

uc_params=load_uc_params; % unit cell
sc_params=load_sc_params; % rectangular transport supercell
structure_param = load_structure_params; % device structure, interaction range, etc

% load the coordinates of the Wannier function centers and the atomic
% coordinates and find the closest atom to each WF. The atom variable is a
% struct with each element containing the type and position of the atom and
% a list of the WF indices that are centered on it

atom=find_centers(uc_params.unit_cell_vectors,uc_params.exclude_wfs);

% create a rectangular supercell

display('creating the supercell')

if (isfield(sc_params,'corner'))
    sc = make_rectangular_supercell(atom,uc_params.unit_cell_vectors,sc_params.sc_vectors,sc_params.directions,0,sc_params.corner);
else
    sc = make_rectangular_supercell(atom,uc_params.unit_cell_vectors,sc_params.sc_vectors,sc_params.directions,sc_params.miny);
end

% create a list of all atoms in the supercell in a given region of the
% device, and order the atoms by their x, y, z positions.

display('ordering the atoms')

if (isfield(structure_param,'supercell_atom_list')) % in case the atom indices are given in the supercell already
    structure_param = reorder_atoms_using_supercell_atom_list(structure_param,sc,sc_params.directions);
else
    structure_param = reorder_atoms(structure_param,sc,sc_params.directions);
end

% write the atomic structure in an .xyz file

display('writing the atom positions into file')
write_atom_positions();

% extract the unit cell data from the supercell

uc=sc.uc;

% extract some data defined in the structure parameters

r_cut = structure_param.r_cut;
L= structure_param.L;
Nregions=structure_param.Nregions;

% determine how many neighbors of the supercell are needed to account for
% the given interaction range in the transport- and in the periodic
% directions. The supercell should be large enough such that every
% interactions fit into maximum first nearest-neighbor supercells.

[NN_t,NN_p,NN_y] = getmaxNNs(sc,abs(r_cut));

if (NN_p > 1 || NN_y > 1 || NN_t > 1)
    display('Warning: more than one neighbor cell is required in the periodic direction at this interaction range.');
    display('Interactions beyond first nearest-neighbor cells will be neglected in the Hamiltonian files.');
    display('It does not affect the band structure calculation, where all the required blocks are accounted for)');
    display(['r_cut = ',num2str(r_cut)]);
    display(['L_z = ',num2str(norm(sc.periodic_axis.vect))]);
    display(['L_y = ',num2str(norm(sc.confined_axis.vect))]);
    display(['L_x = ',num2str(norm(sc.transport_axis.vect))]);
    display(['NN_p = ',num2str(NN_p)]);
    display(['NN_y = ',num2str(NN_y)]);
    display(['NN_t = ',num2str(NN_t)]);
end

% cell length along the transport direction

L_cell = norm(sc.transport_axis.vect);

% total number of Wannier functions in each region (initialize with zeros)

Nwf_per_region = zeros(1,Nregions+1);

% number of supercells along the transport direction in each region (initialize with zeros)

N_cell = zeros(1,Nregions);

% index the Wannier functions by how they appear when going through all the
% atoms in the x,y,z ordered list, and create a list that maps these
% indices to the atom indices. Eg: Atom 1: Mo, WF:1-5. Atom 2: S_top, WF:
% 6-8. Atom 3: S_bottom, WF: 9-11. After ordering by x,y,z assume we get
% the atomic order of 3,1,2. The list would be then 3 3 3 1 1 1 1 1 2 2 2
% Initialize with zeros:

wf_to_atom_indices=zeros(1,sc.Nwf);


% fill up the above variables in the virtual region where all the atoms
% from the unit cell are present

display('indexing the Wannier functions and the atoms')

region = Nregions+1;

% loop through all the atoms (in the supercell) in this region

for var_i = 1:length(structure_param.atom_list{region})
    
    % get the actual atom index
    
    atom = structure_param.atom_list{region}(var_i);        
    
    % get the atom index in the unit cell
    
    atom_uc = mod(atom-1,uc.NA)+1;    
    
    % fill up the next NWf entries of the list with the atom index in the
    % supercell
    
    wf_to_atom_indices((Nwf_per_region(region)+1) : (Nwf_per_region(region)+length(uc.atom(atom_uc).wfs))) = ... 
        atom*ones(1,length(uc.atom(atom_uc).wfs));
    
    % count the WFs
    
    Nwf_per_region(region) = Nwf_per_region(region) + length(uc.atom(atom_uc).wfs);
end

% Here the Wannier function are indexed just from 1 to Nwf.
wf_list{region}=1:sc.Nwf;


% In the different regions of the device make a list of the Wannier
% function indices as they appear in the supercell while going through all
% the atoms. E.g.: if we had just the three atoms (Mo S S) in the 
% supercell with the ordering assumed in the example above, wf_list would 
% be 9 10 11 1 2 3 4 5 6 7 8 (WF 9-11 on bottom S, 1-5 on Mo, 6-8 on top S)

for region=1:Nregions
    
    % number of cells in this region
    
    N_cell(region) = round(L(region)/L_cell);
    
    % loop through all the atoms of the supercell in this region
    
    for var_i = 1:length(structure_param.atom_list{region})
        
        % get the actual atom index
        
        atom = structure_param.atom_list{region}(var_i);
        
        % get the atom index in the unit cell
        
        atom_uc = mod(atom-1,uc.NA)+1;
        
        % get those WF indices from the full list that correspond to this
        % atom index
        
        wf_list{region}((Nwf_per_region(region)+1) : (Nwf_per_region(region)+length(uc.atom(atom_uc).wfs))) = wf_list{Nregions+1}(wf_to_atom_indices==atom);    
        
        % count the WFs
        
        Nwf_per_region(region) = Nwf_per_region(region) + length(uc.atom(atom_uc).wfs);   
    end
    
    
end

% If the Hamiltonian blocks were supported as the argument of this function,
% then don't calculate them again.

if ~exist('Hblocks_full','var')
    
    % load the Hamiltonian matrix in the Wannier basis. Remove the variable
    % length header lines
    display('reading wannier90_hr.dat')
    
    fid=fopen('wannier90_hr.dat','r');
    nrpts=textscan(fid, '%s', 1, 'delimiter', '\n', 'headerlines', 2);
    nrpts=str2num(nrpts{1}{1});
    fclose(fid);
    hr=importdata('wannier90_hr.dat',' ',3+ceil(nrpts/15));
    hr=hr.data;
    
    % create an 5 dimensional matrix from the data. First 3: unit cell index,
    % 4-5: WF1 and WF2 index.
    
    display('reshaping the Hamiltonian')
    
    H123 = hr_order(hr);
    
    % in case there were small imaginary parts, just remove it
    
    H123 = real(H123);
    
    % This is the most important part. This function will create the
    % Hamiltonian blocks corresponding to the interactions within the supercell
    % (the center block) or between the atoms in one cell and in some
    % neighboring one. The linear size of the blocks is the total number of the Wannier
    % functions, and their order is based on the ordering of the atoms. Here
    % all the atoms in the unit cell are considered (atom_list{Nregions+1} is
    % used). Later, when putting together the different parts (tiling the
    % blocks to create the device Hamiltonian) some parts might be removed if
    % in some region not all the atoms of the unit cell are present.
    
    display('creating the H blocks')
    
    Hblocks_full=create_Hblocks(H123,sc,r_cut,NN_t,NN_p,NN_y,structure_param.atom_list{Nregions+1});
    
end

% Interactions within the x-z plane (H0, H+, and H-)
display('H4')
H4 = create_Hamiltonian_with_periodic_shift(0,0,Hblocks_full,Nwf_per_region,wf_list,N_cell,structure_param);
save_Hamiltonians_binary(H4,'H_4.bin');
clear H4

display('H5')
H5 = create_Hamiltonian_with_periodic_shift(1,0,Hblocks_full,Nwf_per_region,wf_list,N_cell,structure_param);
save_Hamiltonians_binary(H5,'H_5.bin');
clear H5

display('H3')
H3 = create_Hamiltonian_with_periodic_shift(-1,0,Hblocks_full,Nwf_per_region,wf_list,N_cell,structure_param);
save_Hamiltonians_binary(H3,'H_3.bin');
clear H3


% If it's a 3D material then also create the connections in the +y and -y
% directions

if (structure_param.dimensions == 3)
    
    display('H1')
    H1 = create_Hamiltonian_with_periodic_shift(0,-1,Hblocks_full,Nwf_per_region,wf_list,N_cell,structure_param);
    save_Hamiltonians_binary(H1,'H_1.bin');
    clear H1
    
    display('H2')
    H2 = create_Hamiltonian_with_periodic_shift(1,-1,Hblocks_full,Nwf_per_region,wf_list,N_cell,structure_param);
    save_Hamiltonians_binary(H2,'H_2.bin');
    clear H2
    
    display('H0')
    H0 = create_Hamiltonian_with_periodic_shift(-1,-1,Hblocks_full,Nwf_per_region,wf_list,N_cell,structure_param);
    save_Hamiltonians_binary(H0,'H_0.bin');
    clear H0
    
    display('H7')
    H7 = create_Hamiltonian_with_periodic_shift(0,1,Hblocks_full,Nwf_per_region,wf_list,N_cell,structure_param);
    save_Hamiltonians_binary(H7,'H_7.bin');
    clear H7
    
    display('H8')
    H8 = create_Hamiltonian_with_periodic_shift(1,1,Hblocks_full,Nwf_per_region,wf_list,N_cell,structure_param);
    save_Hamiltonians_binary(H8,'H_8.bin');
    clear H8
    
    display('H6')
    H6 = create_Hamiltonian_with_periodic_shift(-1,1,Hblocks_full,Nwf_per_region,wf_list,N_cell,structure_param);
    save_Hamiltonians_binary(H6,'H_6.bin');
    clear H6
    
end


% ----------
% Band structure calculation.
%
% It first creates a 3xnumber_of_k_points matrix of the k points, either by
% connecting the points (corners) specified in the 
% load_structure_params.m file ('line' mode) or by creating a regular
% grid of Nk1*Nk2 k points ('grid' mode).
display('calculating the band structure')

L1 = sqrt(sc.transport_axis.vect*sc.transport_axis.vect');
L2 = sqrt(sc.periodic_axis.vect*sc.periodic_axis.vect');
L3 = sqrt(sc.confined_axis.vect*sc.confined_axis.vect');
d  = sc_params.directions;    
if (strcmp(structure_param.kpoint_mode,'line'))
    Nk=structure_param.kpoint_N;
    corners = structure_param.kpoint_corners;    
    Nc = length(corners(:,1));
    k=zeros(3,Nk*(Nc-1));
    for var_c=1:(Nc-1)
        c1=corners(var_c,:);
        c2=corners(var_c+1,:);
        if (c2(1)-c1(1)==0)
            c1(1)=c1(1)+1e-12;
        end
        if (c2(3)-c1(3)==0)
            c1(3)=c1(3)+1e-12;
        end
        if (c2(2)-c1(2)==0)
            c1(2)=c1(2)+1e-12;
        end
        k(d(1),((var_c-1)*Nk+1):var_c*Nk)=c1(1):(c2(1)-c1(1))/(Nk-1):c2(1);
        k(d(2),((var_c-1)*Nk+1):var_c*Nk)=c1(2):(c2(2)-c1(2))/(Nk-1):c2(2);
        k(d(3),((var_c-1)*Nk+1):var_c*Nk)=c1(3):(c2(3)-c1(3))/(Nk-1):c2(3);
    end
    k(d(1),:)=k(d(1),:)*2*pi/L1;
    k(d(2),:)=k(d(2),:)*2*pi/L3;
    k(d(3),:)=k(d(3),:)*2*pi/L2;    
elseif (strcmp(structure_param.kpoint_mode,'grid'))
    Nk1=structure_param.kpoint_N1;
    Nk2=structure_param.kpoint_N2;
    k1 = repmat((-pi/L1):((2*pi/L1)/(Nk1-1)):pi/L1,1,Nk2);
    ktmp = [0:(pi/L2/(Nk2-1)):pi/L2];
    ktmp = ones(1,Nk1)' * ktmp;
    k2 = ktmp(1:end);
    k=zeros(3,Nk1*Nk2);
    k(sc.axes(1),:)=k1;
    k(sc.axes(3),:)=k2;
    
% don't crash if nothing is defined, just do a Gamma point calculation
else        
    k=[0 0 0]';
end
    

% Sum up the Hamiltonian blocks with the appropriate e^{ikr} factors for
% each k point and each different region where the band structure should be
% calculated, then find its eigenvalues and sort them.

for Ik=1:length(k(1,:))    
    reg_index=1;
    for region=structure_param.bandstructure_regions
        H = zeros(Nwf_per_region(region),Nwf_per_region(region));
        for Ix = 1:(1+2*NN_t)
            for Iz= 1:(1+2*NN_p)
                for Iy=1:(1+2*NN_y)
                    r = sc.transport_axis.vect * (NN_t+1-Ix) + sc.periodic_axis.vect *(NN_p+1-Iz) + sc.confined_axis.vect *(NN_y+1-Iy);
                    H=H+exp(1i*r*k(:,Ik))*squeeze(Hblocks_full{Ix,Iz,Iy}(wf_list{region},wf_list{region}));                
                end
            end
        end
        [~, E]=eig((H+H')/2);
        [E ~]=sort(real(diag(E)));
        Ek{reg_index}(:,Ik)=E;        
        reg_index=reg_index+1;
    end
end


end


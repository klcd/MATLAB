clear all

if 0
    
a_tot = (6+5)*6*36+96*13;%+36;
wf_tot = (6+5)*6*36*6+96*13*2;%+36*6;

rs{1}.pos = 'beg';
rs{1}.list = 1:3*6*36*6;
atom_remove_list = 1:3*6*36;
remove_hbn_layers = [6:9];

rs{2}.pos = 'end';
rs{2}.list = wf_tot-1*6*36*6+1:wf_tot;
atom_remove_list = [atom_remove_list a_tot-1*6*36+1:a_tot];

rs{3}.pos = 'mid';
rs{3}.list = 6*6*36*6+5*96*2+1:6*6*36*6+9*96*2;
atom_remove_list = [atom_remove_list 6*6*36+5*96+1:6*6*36+9*96];

atom_numbers = [6*6*36+5*96 6*6*36+9*96+1];

%% Remove the atoms from the atom_position.xyz
downsize_atomposition(atom_remove_list,length(remove_hbn_layers),atom_numbers,'../','./');

%% Remove the wf from the Hamiltonian
downsize_Hamiltonian_general(rs,'../','./');

%% Write the lattice_dat
write_lattice_dat('./','./');

%% Write Smin_dat
downsize_smin([1:3 12],'../','./');
% of the remaining blocks, shorten the 4th by 4 layers
reduce_blocksize_smin(4,4*96*9,'./','./');

end

if 1
a_tot = (6+5)*6*36+96*13+36;
wf_tot = (6+5)*6*36*6+96*13*2+36*6;

% rs{1}.pos = 'beg';
% rs{1}.list = 1:3*6*36*6;
% atom_remove_list = 1:3*6*36;
% remove_hbn_layers = [6:9];
atom_remove_list = [];
rs{1}.pos = 'end';
rs{1}.list = wf_tot-1*6*36*6+1:wf_tot;
atom_remove_list = [atom_remove_list a_tot-1*6*36+1:a_tot];

% rs{3}.pos = 'mid';
% rs{3}.list = 6*6*36*6+5*96*2+1:6*6*36*6+9*96*2;
% atom_remove_list = [atom_remove_list 6*6*36+5*96+1:6*6*36+9*96];

% atom_numbers = [6*6*36+5*96 6*6*36+9*96+1];

%% Remove the atoms from the atom_position.xyz
downsize_atomposition(atom_remove_list,0,[1 1],'../','./');

%% Remove the wf from the Hamiltonian
downsize_Hamiltonian_general(rs,'../','./');

%% Write the lattice_dat
write_lattice_dat('./','./');

%% Write Smin_dat
downsize_smin([12],'../','./');
% of the remaining blocks, shorten the 4th by 4 layers
% reduce_blocksize_smin(4,4*96*9,'./','./');
end
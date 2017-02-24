function [B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_cart2dir(filename, new_filename)
% function to read data from POSCAR files
% CALL: [B,Ap,a,N,T,id,crystal] = read_poscar(filename)
%
% terminology:
% - Na: # of atoms in POSCAR
% - Nsp: # of atomic species in POSCAR
%
% input args:
% - filename: name of the POSCAR file, default: 'POSCAR'
%
% output args:
% - B: cell vectors as columns, size 3x3
% - Ap: atomic positions, size 3xNa
% - Ac: atomic positions in cart. coords
% - a: lattice constant
% - N: array of total number of atoms per species, size 1xNsp
% - T: array of atomic types, size 1xNa
% - id: cell array of strings, size 1xNsp
% - crystal: true if Ap are in crystal coordinates

%% default argument
if nargin == 1
    new_filename = filename;
end

if nargin<1
    filename = 'POSCAR';
    new_filename = filename;
end

[B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar(filename);

if crystal == 0
    Ac = inv(B)*Ap;
    vasp_write_poscar(B,Ac,a,N,id,1,sel_dyn, dyn_tag, new_filename)
else
    disp('Coordinates are already in fractional coordinates')
end

end
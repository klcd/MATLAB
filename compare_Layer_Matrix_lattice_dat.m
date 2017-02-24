function [ ] = compare_Layer_Matrix_lattice_dat( )
%COMPARE_LAYER_MATRIX_ATOM_POSITION Summary of this function goes here
%   Detailed explanation goes here

L = dlmread('Layer_Matrix.dat');
L = L(:,1:3);

a = dlmread('lattice_dat',' ',6,1);
[m,n] = size(a);
if n==6
    a = a(:,2:2:end);
elseif max(a(:)) == 0
    a = dlmread('lattice_dat','\t',6,1);
end

% 10*L-a

isequaltol(10*L,a,1e-13)
end
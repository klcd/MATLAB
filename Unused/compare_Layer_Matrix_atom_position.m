function [ ] = compare_Layer_Matrix_atom_position( )
%COMPARE_LAYER_MATRIX_ATOM_POSITION Summary of this function goes here
%   Detailed explanation goes here

L = dlmread('Layer_Matrix.dat');
L = L(:,1:3);

a = dlmread('atom_position.xyz','\t',2,1);



isequaltol(10*L,a,1e-13)
end
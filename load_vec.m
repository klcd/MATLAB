function [ vec ] = load_vec( c )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

fid = fopen('lattice_dat');
fgetl(fid);fgetl(fid);

v = textscan(fid,'%f %f %f',3);

vec = [v{1} v{2} v{3}];
sc = load_structure_params();
if strcmp(c,'right')
    vec(1,1) = sc.right_L;
elseif strcmp(c,'left')
    vec(1,1) = sc.left_L;
end
end


function [ Vpot ] = load_potential( L,dx,phi,Vbias,Ef,shape )
%LOAD_POTENTIAL Summary of this function goes here
%   Detailed explanation goes here

if strcmp(shape,'rect')
    Vpot = Ef+linspace(phi,phi-Vbias,L/dx);
else
    error('This shape is not supported!');
end
end


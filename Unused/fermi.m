function [ f ] = fermi( E,Ef,kbT )
%FERMI Summary of this function goes here
%   Detailed explanation goes here

f = 1./(exp((E-Ef)/kbT)+1);
end


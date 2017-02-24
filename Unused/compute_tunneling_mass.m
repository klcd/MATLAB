function [ mt, mtE ] = compute_tunneling_mass( E, TE, Vpot, dx )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% constants
hbar = 1.05457e-34;     % [Js]
m0 = 9.10938e-31;       % [kg]
q = 1.60217e-19;        % [1]

tmp = repmat(Vpot,length(E),1)-repmat(E,1,length(Vpot));
tmp(tmp<0) = 0; % if the barrier is crossed early, ignore the rest of the contribution

mtE = hbar^2*log(TE).^2./(4*2*m0*q*(trapz(sqrt(tmp),2)*dx*1e-9).^2);

mt = mean(mtE);
end


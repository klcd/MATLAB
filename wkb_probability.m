function [ T ] = wkb_probability( Vpot,E,L,dx,m )
%WKB_PROBABILITY Summary of this function goes here
%   Detailed explanation goes here

% constants
hbar = 1.05457e-34;     % [Js]
m0 = 9.10938e-31;       % [kg]
eV_to_J = 1.60217e-19;  % [1]

tmp = repmat(Vpot,length(E),1)-repmat(E,1,length(Vpot));
tmp(tmp<0) = 0; % if the barrier is crossed early, ignore the rest of the contribution

% find the new length for each energy
% tmp_L = sum(tmp==0,2); % number of zeros in each row
% L = L-tmp_L*dx; % update the length for each energy

T = exp(-2/hbar*trapz(sqrt(2*m0*m*tmp*eV_to_J),2)*dx*1e-9);
end


function [ k,Ek ] = parabolic_band( m, a )
%parabolic_band Computes the band of an effective mass.
%   Computes the band corresponding to the effective mass m
%   from 0 to pi/a.

hbar = 1.05457e-34;     % [Js]
m0 = 9.10938e-31;       % [kg]
q = 1.60217e-19;        % [1]

% E(k) = hbar^2*k^2/(2*mstar)
k = linspace(0,pi,20)/a;
Ek = hbar^2*k.^2/(2*m*m0*q);

end


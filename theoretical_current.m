function [ It ] = theoretical_current( V, phi, m, width, A )
%UNTITLED Summary of this function goes here
%   Computes the current through a rectangular barrier, after Simmons
%   INPUT
%   V: applied bias [V]
%   phi: barrier height [V]
%   width: width of the barrier [Anstrom]
%   A: Area of the device, set A=1 for It [A/mum^2]
%   OUTPUT
%   It: tunneling current in the device

% formula as in the simmons paper [A/cm^2]
if V <= phi
    It = 6.2e10/width^2*( ...
        (phi-V*0.5).*exp(-1.025*width*sqrt(phi-0.5*V)) - ...
        (phi+0.25*V).*exp(-1.025*width*sqrt(phi+0.25*V)) ...
         );
else
    F = V/width;
    It = 3.38e10*(F.^2/phi).*( ...
        exp(-0.689*phi^1.5./F*sqrt(m)) - ...
        (1+2*V/phi).*exp(-0.689*phi^1.5./F.*sqrt(1+2*V/phi)*sqrt(m)) ...
        );
end

It = It*1e4; % convert to A/m^2

It = It*A*1e-12; % Multiply with the area
end


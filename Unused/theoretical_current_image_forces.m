function [ It ] = theoretical_current_image_forces( V, phi, width )
%UNTITLED Summary of this function goes here
%   Computes the current through a rectangular barrier, after Simmons
%   INPUT
%   V: applied bias [V]
%   phi: barrier height [V]
%   width: width of the barrier [Anstrom]
%   OUTPUT
%   It: tunneling current [A/m^2] or equally [pA/mum^2]

% formula as in the simmons paper [A/cm^2]
It = 6.2e10/width^2*(...
    (phi-V*0.5)*exp(-1.025*width*sqrt(phi-0.5*V)) ...
     - (phi+0.25*V)*exp(-1.025*width*sqrt(phi+0.25*V)) ...
     );
 
 It = It*1e4; % convert to A/m^2
end


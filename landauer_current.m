function [ Ilr ] = landauer_current( E, dE, TE, Efl, Efr, Temp )
%LANDAUER_CURRENT Summary of this function goes here
%   Detailed explanation goes here

% physical constants
e = -1.6021766208e-19;  % [C]
hbar = 1.05457e-34;     % [Js]
k = 8.6173324e-5;       % [eV/K]
eV_to_J = 1.60217e-19;  % [1]

% current
Ilr = e/(hbar*pi)*trapz(TE.*(fermi(E,Efl,k*Temp)-fermi(E,Efr,k*Temp)))*dE*eV_to_J*1e9;
% trapz(TE.*(fermi(E,Efl,k*Temp)-fermi(E,Efr,k*Temp)))
% figure
% hold on
% plot((fermi(E,Efl,k*Temp)-fermi(E,Efr,k*Temp))*max(TE),E)
% plot(TE,E)
% plot(TE.*(fermi(E,Efl,k*Temp)-fermi(E,Efr,k*Temp)),E)

end


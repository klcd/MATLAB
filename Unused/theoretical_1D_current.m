function [ ] = theoretical_1D_current( )
%THEORETICAL_1D_CURRENT Summary of this function goes here
%   Detailed explanation goes here

% Inputvariables
Ef = 0;             % Fermi energy [eV]
Vbias = 0:0.1:1;    % applied voltage [V]
dE = 0.001;         % energy discretisation [eV]
dx = 0.001;          % spatial discretisation [nm]
L = 3;             % length of the barrier [nm]
phi = 1;            % height of the barrier [eV]

% constants
Temp = 300;         % temperature
Efl = Ef;           % fermi level on the left
m = 0.1;              % effective electron mass
tail_E = 0.3;

Ilr = zeros(1,length(Vbias));
% figure
% hold on
for ii=1:length(Vbias)
    % set energy integration domain
    Efr = Ef-Vbias(ii); % fermi level on the right
    E = min(Efl,Efr)-tail_E:dE:max(Efl,Efr)+tail_E;
    E = E(:);
    % generate a rectangular potential
    Vpot = load_potential(L,dx,phi,Vbias(ii),Ef,'rect');
    % compute the transmission probability
    TE = wkb_probability(Vpot,E,L,dx,m);
%     plot(TE,E);
    % compute the current
    Ilr(ii) = landauer_current(E,dE,TE,Efl, Efr, Temp);
end
% hold off
figure;
plot(Vbias,Ilr);
xlabel('Bias voltage [V]');
ylabel('Junction current [A/m^2]');

end


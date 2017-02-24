function [ ] = tunneling_mass( )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

hbar = 1.05457e-34;     % [Js]
q = 1.60217e-19;        % [1]
m0 = 9.10938e-31;       % [kg]

% dimensions of the device
L = 3; % [nm]
dx = 0.3; % [nm]
Ef = 7.1678; % fermi energy in OMEN [eV]
phi = 2.74; % height of the barrier [eV]
shape = 'rect'; % shape of the barrier without a bias
type = 'e';

% for uu = 0.2:1.6
%     % go to the right directory
%     if ~mod(uu,1)
%         cd(num2str(uu))
%     else
%         cd([num2str(uu) '.0'])
%     end
    % load and reshape the data
    % transmission probability
    TE = load('MEL_TE_0_0_0_0.dat');
%     TE = flipud(TE(:));
    TE = TE(:);
    % energy
    E = load('MEL_E_0_0_0_0.dat');
    if strcmp(type,'h')
        E = flipud(E(:))-Ef;
    elseif strcmp(type,'e')
        E = E(:)-Ef;
    end
    % get the bias [V]
%     U = uu;
    U = 0.5;
    % compute the potential
    Vpot = load_potential(L,dx,phi,U,0,shape);
    % compute the tunneling mass
    [mt, mtE] = compute_tunneling_mass(E,TE,Vpot,dx);

    % plot the resulting mass as a function of energy
    figure
    plot(mtE,E,'o')
    hold on
    plot(mt*ones(size(E)),E)
    xlabel('tunneling mass')
    ylabel('energy [eV]')
    legend('tunneling mass','average tunneling mass')
    % plot the transmission probability
    figure
    plot(TE,E)
    
    p = polyfit(mtE,E,1);
    
    m = p(2)+p(1)*phi
    alpha = p(2)/(p(1)+(p(2)*phi))
    % TODO: plot the band
    
    k = linspace(0,pi/6e-10,51);
%     phi = phi*q;
    E = ((2*alpha*phi-1)+sqrt(1+4*alpha*hbar^2*k.^2/(2*m*m0*q)))/(2*alpha);
    figure
    plot(k*6e-10,E);
%     cd ..
% end

end


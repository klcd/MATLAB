function [ me, mh ] = effective_mass_omen( )
%EFFECTIVE_MASS Summary of this function goes here
%   Detailed explanation goes here

%% load the omen data
CB_E = load('CB_Ekr.dat');
VB_E = load('VB_Ekr.dat');
k = load('CB_k.dat');
k = k/0.05e-9;
%% plot the hBN band strcuture
if false
    E = load('MEL_E_0_0_0_0.dat'); %#ok<UNRCH>
    figure
    plot(k,VB_Ekr,'.b')
    hold on
    plot(k,CB_Ekr,'.r')
    ylim([min(E) max(E)])
    xlim([min(k) max(k)])
    a = gca;
    a.XTick = [min(k) 0 max(k)];
    a.XTickLabel = {'X';'\Gamma';'X'};
    a.YTickLabel = {};
    title('Band structure in hBN from OMEN')
    ylabel('Energy [eV]')
end

me = effective_mass(k,CB_E(1,:),'e');
mh = effective_mass(k,VB_E(1,:),'h');
% plot(k,[CB_E(1,:) ; VB_E(1,:)],'b')

end


function [ fermi_energy ] = get_Fermi_level(N_DS,Ek)
% Fermi energy based on the donor doping density and the bandstructure
Nk = length(Ek(1,:));
% Nk=Nk^3; % in 3D
Ef1 = 0;
Ef2 = 50;
Ef3 = 100;

% interval halving
for var_i = 1:100    
    N_DS_new = 2*sum(sum(fermi(Ek,Ef2,300*8.6173324e-5))) / Nk;
    if (N_DS_new > N_DS)
        Ef3 = Ef2;
        Ef2 = Ef1 + (Ef2-Ef1)/2;        
    else
        Ef1 = Ef2;
        Ef2 = Ef2 + (Ef3 - Ef2)/2;
    end
end

fermi_energy = Ef2;

end

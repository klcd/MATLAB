function [ m ] = effective_mass_at_k( k, Ek, ind, dir, type )
%effective_mass Compute the effective mass of a given band
%   Computes the effective mass at the minimum or the maximum of a given
%   band.
%   k: k-points
%   Ek: the energy values corresponding to the k-points [eV]
%   type: may take the string e or h to specify electrons or
%   holes. Default is e. If a valence band is given without setting type,
%   the result will not be useful i.e. not give the negative hole mass.

%% Constants
q = 1.6022e-19;
hbar = 1.0546e-34; % in J s
m0 = 9.1093e-31; % in kg

%% Make the parabola open upwards
if nargin > 4
    if strcmp(type,'h')
        Ek = -Ek;
    elseif strcmp(type,'e')

    else
        error('type not recognised!')
    end
end

%% compute the effective masses
min_E = ind;
nf = 3;

if strcmp(dir,'back')
    dk = sqrt(sum((k(:,min_E-2)-k(:,min_E)).^2))*0.5;
    dE_dk_cb = (Ek(1,min_E-2)+Ek(1,min_E)-2*Ek(1,min_E-1))*dk^-2;
    inds = min_E-floor(0.5*nf):min_E+floor(0.5*nf);
    dk = [0 sqrt(sum((diff(k,1,2)).^2,1))];
    k = cumsum(dk);
    [p, ~, m] = polyfit(k(inds),Ek(inds),2);
    dEdk = p(1)/m(2)^2;
elseif strcmp(dir,'forw')
    dk = sqrt(sum((k(:,min_E)-k(:,min_E+1)).^2))*0.5;
    dE_dk_cb = (Ek(1,min_E-1)+Ek(1,min_E+1)-2*Ek(1,min_E))*dk^-2;
    inds = min_E-floor(0.5*nf):min_E+floor(0.5*nf);
    dk = [0 sqrt(sum((diff(k,1,2)).^2,1))];
    k = cumsum(dk);
    [p, ~, m] = polyfit(k(inds),Ek(inds),2);
    dEdk = p(1)/m(2)^2;
end


% if min_E == 1
%     dk = sqrt(sum((k(:,min_E)-k(:,min_E+1)).^2));
%     % eV/(1/m^2) = eV*m^2
%     dE_dk_cb = (Ek(1,min_E)+Ek(1,min_E+2)-2*Ek(1,min_E+1))*dk^-2;
%     [p, ~, m] = polyfit(k(1:nf),Ek(1:nf),2);
%     dEdk = p(1)/m(2)^2;
% elseif min_E == length(Ek)
%     dk = sqrt(sum((k(:,min_E)-k(:,min_E+1)).^2));
%     dE_dk_cb = (Ek(1,min_E)+Ek(1,min_E-2)-2*Ek(1,min_E-1))*dk^-2;
%     [p, ~, m] = polyfit(k(end-nf+1:end),Ek(end-nf+1:end),2);
%     dEdk = p(1)/m(2)^2;
% else
%     dk = sqrt(sum((k(:,min_E)-k(:,min_E+1)).^2))*0.5;
%     dE_dk_cb = (Ek(1,min_E-1)+Ek(1,min_E+1)-2*Ek(1,min_E))*dk^-2;
%     inds = min_E-floor(0.5*nf):min_E+floor(0.5*nf);
%     dk = [0 sqrt(sum((diff(k,1,2)).^2,1))];
%     k = cumsum(dk);
%     [p, ~, m] = polyfit(k(inds),Ek(inds),2);
%     dEdk = p(1)/m(2)^2;
% end
% J^2*s^2/(kg*eV/m*J/eV)
m = hbar^2/(m0*dEdk*q)
m = hbar^2/(m0*dE_dk_cb*q)
% figure
% [ke,Ek] = parabolic_band(m,a);
% plot(kz-min(kz),E_edge(2,:)-min(E_edge(2,:)),'o-r','MarkerSize',3)
% hold on
% plot(ke,Ek,'b');

end
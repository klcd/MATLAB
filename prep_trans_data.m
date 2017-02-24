function [Data] = prep_trans_data(val,con,nb_val)
%Prepares the K points and Energy values for band to band transition plots
%in 2D hexagonal data.

%The first two rows are the kpoints in cartesian coordinates and the third
%is are the energy differences between band val and con.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Loading the evaluated kpoints in the IBZ
disp('Read K-points')
fid = fopen('IBZKPT');
kpts = textscan(fid,'%f %f %f %f','headerLines',3);
fclose(fid);

kpts = [kpts{[1:4]}];
Base = vasp_brioullin_base('POSCAR');
nr_kpt = size(kpts,1);


%Shift the coordinates back to IBZ
kpts = kpts + (kpts<0);

%Transform kpoint coordinates to cartesian cordinates
Base = vasp_brioullin_base('POSCAR');
Kpts = zeros(nr_kpt,3);
for ii = 1:nr_kpt
    Kpts(ii,:) = (kpts(ii,1)*Base(:,1) +  kpts(ii,2)*Base(:,2) +  kpts(ii,3)*Base(:,3))';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Loading energies
load energies.dat
en = reshape(energies,[],size(kpts,1))';
clear energies;

%Calculate transition energies
% val = 9;
% con = 1;
% nb_val = 9;
trans = en(:,nb_val + con) - en(:,val);

%Collect data for transitions.m
Data = [Kpts(:,1:2) trans];

end


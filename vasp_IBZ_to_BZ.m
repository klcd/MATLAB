function [Data] = vasp_IBZ_to_BZ(Prop)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reads the IBZKPT and POSCAR for  a hexagonal 2D unit cell
%in the folder where executed and restores the property contained in 
%Prop to the full BZ
%
% PRE:  Hexagonal 2D unit cell
%       Folder must contain IBZKPT and POSCAR
%       Prop vector must have size = #kpts in IBZ
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Loading the evaluated kpoints in the IBZ
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Add selected propertie to data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Start = [Kpts(:,1:2), Prop];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Rotating the data to retrieve full BZ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rm120 = (rotz(-120)*Start')'+ repmat((Base(:,1)+Base(:,2))',size(Start,1),1);
r120 = (rotz(120)*Start')'+ repmat((Base(:,1))',size(Start,1),1);

Dat1 = [Start;r120;rm120];

c1 = Dat1 + repmat((-1/3*Base(:,2)-2/3*Base(:,1))',size(Dat1,1),1);
m1 = [-c1(:,1) c1(:,2) c1(:,3)];

Dat2 = [c1;m1];
m2 = [Dat2(:,1) -Dat2(:,2) Dat2(:,3)] + repmat(((Base(:,2)-Base(:,1))./3)',size(Dat2,1),1);

Data = unique([[Dat2;m2]+repmat((1/3*Base(:,2)+2/3*Base(:,1))',size(Dat2,1)+size(m2,1),1)],'rows');

clear rm120 r120 Dat1 c1 m1 Dat2 m2;

end

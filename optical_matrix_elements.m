%Assembling Data
nr_atoms = 3;   %Total number of atoms inside the unit cell
%atom_list = {'Mo','Se_{Mo top}','Se_{Mo bottom}','W','Se_{W top}','Se_{W bottom}'};
atom_list = {'Mo' 'Te_{top}' 'Te_{bottom}'};
orbitals = {'s','p','d'};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Parameters in MAT_EL
disp('Load matrix elements')
fid = fopen('MAT_EL.dat');
par = textscan(fid,'%u %u %u %u %u');
fclose(fid);
par = [par{1,1} par{1,2} par{1,3} par{1,4} par{1,5}];
par = par(1,:);

nr_val = par(1,1);
nr_con = par(1,2);
nr_kpt = par(1,4);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Loading and sorting the optical matrix elements
fid = fopen('MAT_EL.dat');
Dat = textscan(fid,repmat('%f ',1,2*nr_con),'headerLines',1);
fclose(fid);


RE_p = zeros(nr_kpt*nr_val*3,nr_con);
IM_p = zeros(nr_kpt*nr_val*3,nr_con);
for ii = 1:nr_con
    RE_p(:,ii) =  Dat{1,2*(ii-1)+1};
    IM_p(:,ii) =  Dat{1,2*(ii)};
end
%Note that ISPIN from is not yet included in this script!!!
Im = zeros(nr_val,nr_con,3,nr_kpt);
Re = zeros(nr_val,nr_con,3,nr_kpt);
for kp = 1:nr_kpt
    for dir = 1:3
        start = (kp-1)*nr_val*3+(dir-1)*nr_val+1;
        ende = start+nr_val-1;
        Im(:,:,dir,kp) = IM_p(start:ende,1:nr_con);
        Re(:,:,dir,kp) = RE_p(start:ende,1:nr_con);
    end
end
clear start ende ii jj IM_p RE_p A Dat Data par kp dir fid

disp('Calculate oscilator strengths.')

os_str = zeros(nr_kpt,6,nr_con,nr_val);
os_imag = zeros(nr_kpt,3,nr_con,nr_val);
trick = [1 2; 1 3; 2 3];
for ncon = 1:nr_con
    for nval = 1:nr_val
        for jj = 1:3           
                os_str(:,jj,ncon,nval) = Re(nval,ncon,jj,:).^2 + Im(nval,ncon,jj,:).^2;
                os_str(:,3+jj,ncon,nval) = real((Re(nval,ncon,trick(jj,1),:)+ i.*Im(nval,ncon,trick(jj,1),:))...
                                              .*(Re(nval,ncon,trick(jj,2),:)- i.*Im(nval,ncon,trick(jj,2),:)));
                os_imag(:,jj,ncon,nval) = imag((Re(nval,ncon,trick(jj,1),:)+ i.*Im(nval,ncon,trick(jj,1),:))...
                                               .*(Re(nval,ncon,trick(jj,2),:)- i.*Im(nval,ncon,trick(jj,2),:)));
        end
    end
end
clear jj ncon nval trick

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Loading the evaluated kpoints in the IBZ
disp('Read K-points')
fid = fopen('IBZKPT');
kpts = textscan(fid,'%f %f %f %f','headerLines',3);
fclose(fid);
kpts = [kpts{[1:4]}];

if size(kpts,1) ~= nr_kpt
    error('Error: Number of Kpoints in MAT_EL and IBZKPT does not agree')
end

%Shift the coordinates back to IBZ
for i = 1:3
    kpts(kpts(:,i) < 0) = kpts(kpts(:,i) < 0) +1;
end

%save the weights
weights = kpts(:,4);

%Transform kpoint coordinates to cartesian cordinates
Base = vasp_brioullin_base('POSCAR');
Kpts = zeros(nr_kpt,3);
for ii = 1:nr_kpt
    Kpts(ii,:) = (kpts(ii,1)*Base(:,1) +  kpts(ii,2)*Base(:,2) +  kpts(ii,3)*Base(:,3))';
end

clear i ii fid;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Import orbital data from the procar
disp('Read procar_matlab.dat')
fid = fopen('procar_matlab.dat');
ol = textscan(fid,'%f %f %f','headerLines',5);
fclose(fid);

ols = [ol{1,1} ol{1,2} ol{1,3}];
clear ol

fid = fopen('procar_matlab.dat');
test = textscan(fid,'%f ','headerLines',2);
fclose(fid);

test = test{1,1};
nr_bands = test(2,1);

%Warnings if some things are not consistent
if test(1,1)~=nr_kpt
    error('The number of K-points in the MAT_EL and the PROCAR-file does not agreed')
end

if nr_bands ~= (nr_val+nr_con)
    disp('Some bands where lost in the calculation of MAT_EL. Check everthing is done rightly!!')
end

clear test;
disp('Sorting Data')
atom = cell(nr_bands,nr_kpt);
for kpt = 1:nr_kpt
    for nband = 1:nr_bands;
        inds = (nband-1)*nr_atoms + (kpt-1)*nr_bands*nr_atoms + 1;
        [~,ind] = max(reshape(ols(inds:inds+nr_atoms-1,:),1,[]));
        orb = floor((ind-1)/nr_atoms);
        atom{nband,kpt} = [atom_list{ind-orb*nr_atoms} ' ' orbitals{orb+1}];
    end
end
clear orb fid i ind inds kpt nband ols ...
atom_list fid IM ind inds kpts ...
    orbitals ;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Finally we have the data as follos
% Kpts:     A nr_kpoint*3 matrix containing the kpoints inside the IBZ
% os_str:   A nr_kpoints*3*nr_val*nr_con matrix containing the matrix elemtent in all
%           directionts at all kpoints for all transitions
% name:     A nr_kpoints*1 cell containing the names from probable initial
%           atom to final atom.

clear Re Im os_imag;
save('optics.mat')
save('param.dat', 'nr_atoms', 'nr_bands', 'nr_con', 'nr_val', 'nr_kpt');
save('kpoints.mat', 'nr_kpt', 'Base', 'Kpts','weights')
save('amplitudes.mat', 'os_str','atom')



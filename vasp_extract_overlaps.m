%Assembling Data
nr_atoms = 6;   %Total number of atoms inside the unit cell
%atom_list = {'Mo','Se_{Mo top}','Se_{Mo bottom}','W','Se_{W top}','Se_{W bottom}'};
%atom_list = {'Mo' 'S' 'S'};
atom_list = {'Mo','Se','Se','W','Se','Se'};
orbitals = {'s','p','d'};

disp('Read procar_matlab.dat')
fid = fopen('procar_matlab.dat');
ol = textscan(fid,'%f %f %f','headerLines',5);
fclose(fid);

ols = [ol{1,1} ol{1,2} ol{1,3}];
clear ol

fid = fopen('procar_matlab.dat');
info = textscan(fid,'%f ','headerLines',2);
fclose(fid);
info = info{1,1};

nr_kpt = info(1,1);
nr_bands = info(2,1);

overlaps = cell(nr_bands,nr_kpt);
for kpt = 1:nr_kpt
    for nband = 1:nr_bands;
        inds = (nband-1)*nr_atoms + (kpt-1)*nr_bands*nr_atoms + 1;
        [~,ind] = max(reshape(ols(inds:inds+nr_atoms-1,:),1,[]));
        orb = floor((ind-1)/nr_atoms);
        overlaps{nband,kpt} = [atom_list{ind-orb*nr_atoms} ' ' orbitals{orb+1}];
    end
end

clear atom_list fid ind inds info kpt nband nr_atoms nr_bands nr_kpt ols orb orbitals test

save('overlaps.mat', 'overlaps')


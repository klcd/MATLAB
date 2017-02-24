function [atoms, minx, maxx, miny, maxy, maxz, minz] = number_atomsorts()

ID = fopen('lattice_dat');
dat = textscan(ID, '%s %f %f %f','headerLines',6);

minx = min(dat{2});
maxx = max(dat{2});

miny = min(dat{3});
maxy = max(dat{3});

minz = min(dat{4});
maxz = max(dat{4});

atom_sorts =unique(dat{1,1});
atoms = struct('sort',[],'count',[])

for i = 1:length(atom_sorts);
    atoms(i).sort = atom_sorts(i);
    atoms(i).count = sum(strcmp(dat{1},atom_sorts(i)));
end






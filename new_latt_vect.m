function [ ] = new_latt_vect( latt_vect )
%Changes the lattice vector inside a POSCAR file
%   Detailed explanation goes here

fin = fopen('POSCAR','r');
fout = fopen('POSCAR_new','w');

idk = 0;

while ~feof(fin);
    idk = idk + 1;
    s = fgetl(fin);
    
    if idk == 2
        s = num2str(latt_vect);
    end
    
    fprintf(fout,'%s\n',s);
end

fclose(fin);
fclose(fout);

system(['mv POSCAR_new POSCAR']);


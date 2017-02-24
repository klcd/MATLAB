function [] = vasp_create_POTCAR(ats)
%Takes a cell list with the atom names and creates a POTCAR file with the
%PBE POTCAR from VASP in the current directory.

% ats = {'W' 'S'};

dir = '~/vasp/potpawPBE/';
dest = pwd;
dest = [dest '/POTCAR'];


ord = 'cat';

for i =1:size(ats,2)
    ord = [ord ' ' dir char(ats{i}) '/POTCAR'];
end

system([ord ' >> ' dest])

end
function vasp_unitcell_change(B_new,a_new,filename)


h = 1;
filename
%Default input files
if ~exist('filename', 'var'), filename = 'POSCAR'; end

%Input from the POSCAR file
[B,Ap,a,N,T,id,crystal] = read_poscar(filename);

%Default variables
if ~exist('B_new','var'), B_new = B; end
if ~exist('a_new','var'), a_new = a; end


%Warning if fractional coordinates are used.
if crystal ==1;
    disp('Coordinates are fractional. Make sure the change in the basis is not too large')
end

%Writing the new POSCAR
write_poscar(B_new,Ap,a_new,N,id,crystal,filename);

end



function [] = vasp_dir_shift_poscar(shift,filename,new_filename)

%Read data from file
[B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar(filename);

shift = shift';

%If its in cartesiant coordinated change it to fractional.
if crystal == 0
    vasp_cart2dir(filename);
    [B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar(filename);
    vasp_dir2cart(filename);
end

%Shift and assure everthing is inside the unit cell.
Ap = Ap + repmat(shift, 1, size(Ap,2));
Ap = Ap + (Ap < 0 ) - (Ap > 1);

vasp_write_poscar(B,Ap,a,N,id,crystal, sel_dyn, dyn_tag,new_filename)


end
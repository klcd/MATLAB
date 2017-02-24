function [] = vasp_cart_shift_poscar(shift,filename,new_filename)



%Read data from file
[B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar(filename);

%Shifts the coordinates by a vector with the units Angstroem.
shift = shift'./a;

%If its in fractional coordinated change it to cartesian.
if crystal == 1
    vasp_dir2cart(filename);
    [B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar(filename);
    vasp_cart2dir(filename);
end

%Apply the shift to all elements and write the new POSCAR file
Ap = Ap + repmat(shift, 1, size(Ap,2));
%new_file = [filename '_shifted'];
new_file = new_filename;
vasp_write_poscar(B,Ap,a,N,id,crystal, sel_dyn, dyn_tag,new_file)
vasp_cart2dir(new_file);

%Check if any atoms have been shifted outside the unit cell
[B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar(new_file);
Ap = Ap + (Ap < 0 ) - (Ap > 1);
vasp_write_poscar(B,Ap,a,N,id,crystal, sel_dyn, dyn_tag,new_file);

end
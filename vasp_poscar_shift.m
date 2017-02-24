filename = 'CONTCAR_cor2x2x1_sc'

[B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar(filename);

if ~crystal
    vasp_cart2dir(filename);
    [B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar(filename);
end


%find suspiciously large values and shift the complete unit cell by the
%smallest of these large values. If 

tol = 1e-1;
susp_x = (Ap(1,:) > max(Ap(1,:) - tol));
susp_y = (Ap(2,:) > max(Ap(2,:) - tol));
susp_z = (Ap(3,:) > max(Ap(3,:) - tol));

extra = 1e-2
shift_x = 1- min(Ap(1,susp_x))+extra;
shift_y = 1- min(Ap(2,susp_y))+extra;
shift_z = 1- min(Ap(3,susp_z))+extra;

if shift_x < 0.1
    Ap(1,:) = Ap(1,:) + shift_x;
end

if shift_y < 0.1
    Ap(2,:) = Ap(2,:) + shift_x;
end

if shift_z < 0.1
    Ap(3,:) = Ap(3,:) + shift_x;
end
for i = 1:length(Ap(1,:))
    if Ap(1,i) >= 1
       Ap(1,i) = Ap(1,i) - 1;
    end
    if Ap(2,i) >= 1
       Ap(2,i) = Ap(2,i) - 1;
    end
    if Ap(1,i) >= 1
       Ap(2,i) = Ap(2,i) - 1;
    end    
end


vasp_write_poscar(B,Ap,a,N,id,crystal, sel_dyn, dyn_tag, [filename '_cor'])




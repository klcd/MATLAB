function [] = vasp_plot_POSCAR(filename,dotsize,cf) 

[B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar(filename);

rem = 0;
if crystal
    vasp_dir2cart(filename, [filename '_temp']);
    [B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar([filename '_temp']);
    rem = 1;
end

cmap = colormap;
color_indes = cmap(cf*T);

figure
scatter3(a*Ap(1,:),a*Ap(2,:),a*Ap(3,:),dotsize,color_indes,'filled')

if rem == 1
    delete([filename '_temp']);
end






end
vasp_version = ' vasp-5.4.1-std.amd '
cores = 20;

%Applied shifts in z_direction
shifts = [2.22:0.025:2.4];

%Atoms that are shifted in eauch run.
atomlist = [4,5,6];

for i = 1:1:length(shifts)
    dir =  strrep(strrep(num2str(shifts(i)),'-','m'),'.','_');
    system(['mkdir ' dir]);
    system(['cp init_files/* ' dir]);
    eval(['cd ' dir])

%     if i ~= 1
%         dir_1 = strrep(strrep(num2str(shifts(i-1)),'-','m'),'.','_');
%         system(['mv ../' dir_1 '/WAVECAR ./'])
%     end
    
    [B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar();

    if crystal ==1 
        vasp_dir2cart;
        [B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar();
    end

    Ap(:,atomlist) = Ap(:,atomlist) - repmat([0,0,shifts(i)],length(atomlist),1)'

    vasp_write_poscar(B,Ap,a,N,id,crystal, sel_dyn, dyn_tag, 'POSCAR')

    system(['mpiexec -n ' num2str(cores) vasp_version])

    cd ../

end


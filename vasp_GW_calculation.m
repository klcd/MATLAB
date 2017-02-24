function [telapsed] = vasp_GW_calculation(cores)
%This script executes a GW calculation from the file in the init_files
%folder
tstart = tic;
vasp_version = 'vasp-5.4.1-std.amd'


%Create backupfolder
system('mkdir backup');
cd('backup');
system('mkdir 1_Wavecar');
system('mkdir 2_Optics');
system('mkdir 3_GW0');
system('mkdir 4_BSE')
cd('../');

%create calculation folder and transfer files for first calculation
system('mkdir GW_calculation');
cd('init_files');
system('cp INCAR_WAVECAR KPOINTS POSCAR POTCAR ../GW_calculation/');
cd('../GW_calculation');
system('mv INCAR_WAVECAR INCAR');

%Do the first calculation and transfer files to backup folder
system(['mpiexec -n 4 ' vasp_version])
system('cp WAVECAR OUTCAR EIGENVAL DOSCAR ../backup/1_Wavecar');

%Get the files for the LOPTICS calculation and do it
system('cp ../init_files/INCAR_OPTICS ./');
system('mv INCAR_OPTICS INCAR');
system(['mpiexec -n ' num2str(cores) ' ' vasp_version])

%transfer files to backup
system('cp WAVECAR WAVEDER OUTCAR EIGENVAL DOSCAR ../backup/2_Optics');

%Get the files for the GW0 calculation and do it
system('cp ../init_files/INCAR_GW ./');
system('mv INCAR_GW INCAR');
system(['mpiexec -n ' num2str(cores) ' ' vasp_version])
system('cp OUTCAR vasprun.xml ../backup/3_GW0');


%%%%
system('cp ../init_files/INCAR_BSE ./');
system('mv INCAR_BSE INCAR');
system(['mpiexec -n 1 ' vasp_version])
system('cp OUTCAR vasprun.xml ../backup/4_BSE');
cd('../')
telapsed = toc(tstart);
save('info.mat', 'cores','telapsed')

end
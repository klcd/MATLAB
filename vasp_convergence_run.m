function [ output_args ] = vasp_convergence_run(cores)
%Imports the necessary files for convergence run. The Incar files has to be
%imported beforhand from 1_relaxation/minimum and corrected if necessary 
%such that we only do no Ionic steps anymore and the EDIFF should be
%augmented.

system(['cp ../1_relaxation/minimum/KPOINTS ./']);
system(['cp ../1_relaxation/minimum/POTCAR ./']);
system(['cp ../1_relaxation/minimum/CONTCAR ./']);
system(['mv CONTCAR POSCAR'])
system(['intelboot']);
system(['intelrun -n ' num2str(cores) ' vasp']);




end


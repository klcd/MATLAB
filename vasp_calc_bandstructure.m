function [ output_args ] = vasp_calc_bandstructure(cores )
%Copies the needed data in 2_scf. INCAR and KPOITS must be written or
%copied by hand. Then calculates and plots the bandstructure.
%   Detailed explanation goes here

%Importing the necessary files from 2_scf.
system(['cp ../2_convergence/POSCAR ./']);
system(['cp ../2_convergence/POTCAR ./']);
system(['cp ../2_convergence/CHGCAR ./']);


%Run Vasp
system(['intelboot']);
system(['intelrun -n ' num2str(cores) ' vasp']);

%Run procar_matlab.pl
system(['procar_matlab.pl PROCAR']);

%Plot bandiagrams
load_procar()

end


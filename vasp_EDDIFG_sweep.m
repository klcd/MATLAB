function [ output_args ] = vasp_EDDIFG_sweep(low_exp, high_exp, cores)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

ediffg = low_exp:1:high_exp;


for i = 1:length(ediffg);
    system(['mkdir EDIFFG_Em', num2str(ediffg(i))]);
    cd (['EDIFFG_Em', num2str(ediffg(i))]);
    system(['cp ../init_files/* ./']);
    
    vasp_keyword_change('INCAR','EDIFF', ['1e-',num2str(ediffg(i)+2)]);
    vasp_keyword_change('INCAR','EDIFFG', ['-1e-',num2str(ediffg(i))]);
   
    system('intelboot')
    system('intelrun -n 4 vasp')
    cd('../')
end


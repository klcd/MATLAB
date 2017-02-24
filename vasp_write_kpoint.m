function [ output_args ] = vasp_write_kpoint(Ndim, Package, NKpt)
%Generates a KPOINTS file with the correcsponding Package
%Ndim = 2,3
%Package = 'Monkhorst', 'Gamma', ..
%Nkpt is an iteger

kid = fopen('KPOINTS','w');

if Ndim == 2
    fprintf(kid,['K-Points\n 0\n' Package '\n ' num2str(NKpt) ' ' num2str(NKpt) ' ' num2str(1) '\n 0 0 0']);
end

if Ndim == 3
    fprintf(kid,['K-Points\n 0\n' Package '\n ' num2str(NKpt) ' ' num2str(NKpt) ' ' num2str(NKpt) '\n 0 0 0']);
end

fclose(kid);

end


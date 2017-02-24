ecut = 300:100:1100;

for ii=1:length(ecut)
    cd(['e' num2str(ecut(ii)) '/']);
    if ii>1
        system(['cp ../e' num2str(ecut(ii-1)) '/* .']);
    end
    disp(num2str(ecut(ii)));
    iid = fopen('INCAR','w');
    
    fprintf(iid,['System bp_bulk\nENCUT = ' num2str(ecut(ii)) ...
        '\nEDIFF = 1E-8\nISTART = 1\nISMEAR = -5\n' ...
        'SIGMA = 0.05\nNELM = 40\nNELMIN = 2\n' ...
        'IBRION = 1\nNSW = 50\nISIF = 3\nEDIFFG = -1e-3\n' ...
        'LVDW = T\nGGA = PE\nVDW_C6 = 3.13 1.23\n' ...
        'VDW_R0 = 1.485 1.397\nALGO = Fast']);
    flose(fid);
    system('intelrun -n 4 vasp > output < /dev/null');
    cd ..
end
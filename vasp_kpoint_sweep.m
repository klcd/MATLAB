dk = 2;
kp = 5:dk:15

ckp = [];
en = [];
figure

for i = 1:length(kp)
    ii = kp(i);
    disp(num2str(ii))
    system(['mkdir ' num2str(ii) 'kp/']);
    cd([num2str(ii) 'kp/']);
    system(['cp ../init_files/*', ' ./']);
    
    kid = fopen('KPOINTS','w');
    fprintf(kid,['K-Points\n 0\nM\n ' num2str(ii) ' ' num2str(ii) ' ' num2str(1) '\n 0 0 0']);
    fclose(kid);
    system('intelboot');
    system('intelrun -n 10 vasp');
   
    
    
    ckp = [ckp, ii]
    
    [~,dat] = unix('tail -1 OSZICAR');
    dat = strsplit(dat);
    en(i)=str2num(char(strrep(dat(6),'E','e')));
    
    
    hold on
    plot(ckp, en,'bo')
    drawnow
    xlabel('Kpoints')
    ylabel('Energy [eV]')
    hold off
    
     cd ..
    
end


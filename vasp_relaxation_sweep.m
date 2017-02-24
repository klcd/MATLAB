function [en, latt_vects, min] = vasp_relaxation_sweep(init_latt, step, end_latt, relaxation_run ,cores)
% Changes the lattice constants in the POSCAR file and runs a vasp
% simulation for all specified lattice constant where

%init_latt: smallest lattice constant
%end_latt: biggest lattice constant
%step: step size of lattice constants
%cores: number of cores on which the vasp simulation is run.

%During the simulation the energies calculated are collected and plotted
latt_vects = init_latt:step:end_latt
en = [];

for i = 1:length(latt_vects);
    
    
    %Create folder and copy files from init_files folder
    system(['mkdir ' num2str(latt_vects(i))]);
    system(['cp init_files/* ' num2str(latt_vects(i))]);
    cd([num2str(latt_vects(i))]);
    
    %Copy CONTCAR from the last
    
    if i>1
        system(['cp ../' num2str(latt_vects(i-1)) '/CONTCAR ./' ]);
        system(['cp CONTCAR POSCAR']);
    end
    new_latt_vect(latt_vects(i));
    system(['intelboot']);
    %system(['intelrun -n ' num2str(cores) ' vasp']);
    system(['intelrun -n ' num2str(cores) ' vasp > output']);
    
    
    [~,conv] = unix('tail -10 output');
    trys = 0;
    
    
    if relaxation_run == 1;
        while ~(length(findstr(conv, 'reached required accuracy')) > 0);
            disp('Run did not converge!!')
            trys = trys+1;
            system(['cp CONTCAR POSCAR']);
            %system(['intelrun -n ' num2str(cores) ' vasp']);
            system(['intelrun -n ' num2str(cores) ' vasp > output']);
            conv = unix('tail -1 output');
            
            if trys > 3
                val = str2num(char(vasp_keyword_value('EDIFF', 'INCAR')));
                val = num2str(val/10);
                vasp_keyword_change('INCAR','EDIFF',strrep(val,'e','E'));
                trys = 0;
            end
        end
    end
    
    
    [~,dat] = unix('tail -1 OSZICAR');
    dat = strsplit(dat);
    en(i)=str2num(char(strrep(dat(6),'E','e')));
    clat_vect = latt_vects(1,1:length(en));
    
%     if plot ==1 & ~(i==1);
%         hold on
%         plot(clat_vect, en,'b.')
%         drawnow
%         xlabel('Lattic Vector [A]')
%         ylabel('Energy [eV]')
%         hold off
%     end
    
    cd(['../']);
    disp('Lattice converged')
end

disp('Minimum calculated')
coeffs = polyfit(latt_vects, en,2);
min = -coeffs(2)/(2*coeffs(1))




end


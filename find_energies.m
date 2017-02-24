function energies = find_energies(do_min, cores)
%Determines the energies from a vasp_relaxation sweep and calculated the
%minimium. 
%do_min = 1 lets run a vasp simulation at the calculated minimum
%cores: determines the number of core on which that simulstion is run.
[~,filepaths] = unix('ls */OSZICAR');
filepaths = strsplit(strtrim(filepaths));
filepaths = filepaths(~cellfun('isempty',filepaths));

lat_consts = str2num(char(strrep(filepaths, '/OSZICAR','')));

commands = strcat('tail -1',{' '},filepaths);

en = zeros(1,length(commands));
for i = 1:length(commands);
    [~,dat] = unix(char(commands(i)));
    dat = strsplit(dat);
    en(1,i)=str2num(char(strrep(dat(6),'E','e')));
end



f = fit(lat_consts,en','poly2');
mini = - f.p2/(2*f.p1)

figure
hold on
plot(lat_consts, en,'b.')
plot(f,lat_consts,en')
plot([mini],[f(mini)],'go')
xlabel('lattice constant [A]')
ylabel('Energy [eV]')
hold off

if do_min ==1
    system(['mkdir minimum']);
    h = abs(lat_consts-mini);
    [~,ind]=min(h);
    system(['cp init_files/* minimum']);
    system(['cp ' num2str(lat_consts(ind)) '/CONTCAR minimum']);
    cd('minimum');
    system(['mv CONTCAR POSCAR']);
    new_latt_vect(mini);
    system(['intelboot']);
    system(['intelrun -n ' num2str(cores) ' vasp'])
    cd('../');

end

end




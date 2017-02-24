function energies = vasp_results_EDDIFG_sweep(do_min, cores)

[~,filepaths] = unix('ls */OSZICAR');
filepaths = strsplit(strtrim(filepaths));
filepaths = filepaths(~cellfun('isempty',filepaths));


ed = regexp(filepaths,'\d','match');

for i = 1:length(ed)
    ediffg(i) = str2num(char(ed{i}));
end
commands = strcat('tail -1',{' '},filepaths);

en = zeros(1,length(commands));
for i = 1:length(commands);
    [~,dat] = unix(char(commands(i)));
    dat = strsplit(dat);
    en(1,i)=str2num(char(strrep(dat(6),'E','e')));
end

figure
plot(ediffg,en,'ro')

end
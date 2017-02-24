[~,filepaths] = unix('ls */OSZICAR');
filepaths = strsplit(strtrim(filepaths));
filepaths = filepaths(~cellfun('isempty',filepaths));

kps = str2num(char(strrep(filepaths, 'kp/OSZICAR','')));

commands = strcat('tail -1',{' '},filepaths);

en = zeros(1,length(commands));
for i = 1:length(commands);
    [~,dat] = unix(char(commands(i)));
    dat = strsplit(dat);
    en(1,i)=str2num(char(strrep(dat(6),'E','e')));
end


figure
hold on
plot(kps, en,'bo')
xlabel('Kpoints')
ylabel('Energy [eV]')
hold off
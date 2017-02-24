[~,filepaths] = unix('ls */OSZICAR');
filepaths = strsplit(strtrim(filepaths));
filepaths = filepaths(~cellfun('isempty',filepaths));

commands = strcat('tail -1',{' '},filepaths);

en = zeros(1,length(commands));

for i = 1:length(commands);
    [~,dat] = unix(char(commands(i)));
    dat = strsplit(dat);
    en(1,i)=str2num(char(strrep(dat(6),'E','e')));
end

shifts = str2num(char(strrep(strrep(strrep(filepaths, '/OSZICAR',''),'m','-'),'_','.')));


[shifts,ind] = sortrows(shifts);
en = en(ind);

f = fit(shifts,en','poly2');
mini = - f.p2/(2*f.p1)

plot(shifts,en,'r.-')
hold on
plot(f,shifts,en','b')
hold off

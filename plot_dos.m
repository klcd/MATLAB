[~,data] = system('tail -n +7 DOSCAR');
data = textscan(data,'%f %f %f %*f',301);

[~,fermi] = system('grep -F "E-fermi" OUTCAR');
fermi = strsplit(fermi);
fermi = str2double(fermi{1,4});

figure
plot(data{1,2},data{1,1})
title('Density of states')
ylabel('Energy [eV]')
xlabel('states per unit cell')
hold on
plot(data{1,2},fermi*ones(size(data{1,1})))
legend('DOS','Fermi Energy')
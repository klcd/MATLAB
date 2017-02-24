function [  ] = plot_procar(  )
%PLOT_PROCAR Reads the PROCAR file and plots the band structure
%   Reads the PROCAR file and plots the band structure. It colors each band
%   according to the orbital that has the highest contribution.

%% Read some parameter from the POSCAR
fid = fopen('POSCAR');
for skip = 1:5
    fgetl(fid);
end
atoms = strsplit(fgetl(fid));
num_atoms = sscanf(fgetl(fid),'%i %i %i');
fclose(fid);

%% Read the number of k-points, bands and ions
fid = fopen('PROCAR');
fgetl(fid);
buff = strsplit(fgetl(fid),':');
Nk = sscanf(buff{2},'%i',1);
Nb = sscanf(buff{3},'%i',1);
Na = sscanf(buff{4},'%i',1);
for skip = 1:5
    fgetl(fid);
end

%% Get the orbitals that are present
orbitals = sscanf(fgetl(fid),'%*s %s %s %s %*s');
fclose(fid);

%% Read the PROCAR data, use sed for simple import of the numbers
if exist('procar.mat','file')
    disp('Reading the procar data from procar.mat ...');
    load('procar.mat');
else
    if isunix
        [~,tmp] = system('tail -n +5 PROCAR | sed -n ''/ion/,/tot/{/ion/b;/tot/b;p}''');
    else
        command = 'tail -n +5 PROCAR | sed -n ''/ion/,/tot/{/ion/b;/tot/b;p}''';
        [~,tmp] = system(['C:\cygwin64\bin\bash --login -c "cd ''' pwd '''; ' command '"']);
    end
    data = str2num(tmp); %#ok<ST2NM>
    save('procar.mat','data')
    data = reshape(data(:,2:4),Na,3*Nk*Nb);
end
% Sum the contribution of all atoms of a kind at each k-point and for each band
contributions = [sum(data(1:num_atoms(1),:),1); sum(data(num_atoms(1)+1:num_atoms(1)+num_atoms(2),:),1); sum(data(num_atoms(1)+num_atoms(2)+1:num_atoms(1)+num_atoms(2)+num_atoms(3),:),1)];
[~,main_contr] = max(reshape(contributions(:),9,Nk*Nb),[],1);

main_contr = mode(reshape(main_contr,Nb,Nk),2);

%% Read the occupation from the PROCAR file
if isunix
    [status,cmdout] = system('awk ''NR>6 && NF==2 { print $1,$2 }'' EIGENVAL');
else
    command = 'awk ''NR>6 && NF==2 { print $1,$2 }'' EIGENVAL';
    [status,cmdout] = system(['C:\cygwin64\bin\bash --login -c "cd ''' pwd '''; ' command '"']);
end
if status
    error(['Akw encountered an error: ' num2str(status) '.'])
end
cmdout

%% Read the EIGENVAL file for the band structure
% Read the appropriate eigen energie values from EIGENVAL
if isunix
    [status,cmdout] = system('awk ''NR>6 && NF==2 { print $1,$2 }'' EIGENVAL');
else
    command = 'awk ''NR>6 && NF==2 { print $1,$2 }'' EIGENVAL';
    [status,cmdout] = system(['C:\cygwin64\bin\bash --login -c "cd ''' pwd '''; ' command '"']);
end
if status
    error(['Akw encountered an error: ' num2str(status) '.'])
end

if ~isempty(strfind(cmdout,'***'))
    warning('More than 999 bands, indexing might be off!')
    cmdout = strrep(cmdout,'***','1000');
end

bands_temp = str2num(cmdout); %#ok<ST2NM>
num_k_per_path = Nk/3;
bands = reshape(bands_temp(:,2),[Nb Nk]);

e_min = min(bands_temp(:,2));
e_max = max(bands_temp(:,2));

%% Read the fermi energy from the OUTCAR file
if isunix
    [status,cmdout] = system('grep E-fermi OUTCAR | awk ''{print $3}''');
else
    command = 'grep E-fermi OUTCAR | awk ''{print $3}''';
    [status,cmdout] = system(['C:\cygwin64\bin\bash --login -c "cd ''' pwd '''; ' command '"']);
end
if status
    error(['grep or akw encountered an error: ' num2str(status) '.'])
end
fermi = str2double(cmdout);

clear status cmdout bands_temp

%% Plot the band structure
figure
% plot(linspace(0,1,Nk-2),bands(1:end,[1:num_k_per_path num_k_per_path+2:2*num_k_per_path 2*num_k_per_path+2:end]))
% Map the colors of the orbital contributions to the plotted bands
color_map = jet(length(unique(main_contr)));
h=plot(linspace(0,1,Nk-2),bands(1:end,[1:num_k_per_path num_k_per_path+2:2*num_k_per_path 2*num_k_per_path+2:end]),'b');
set(gcf,'ColorMap',color_map);
[~,~,colorNo] = unique(main_contr);
for ii=1:length(unique(main_contr))
    set(h(colorNo == ii),'color', color_map(mod(ii-1, length(color_map))+1, :))
end
set(gca,'CLim',[min(main_contr), max(main_contr)])
colorbar

ylabel('Energy [eV]')
hold all
plot(0:1,ones(1,2)*fermi,'r')
plot([1/3 1/3],[e_min e_max],'k')
plot([2/3 2/3],[e_min e_max],'k')

end
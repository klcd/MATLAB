%% Parameters
bands_to_plot = 32;
wannier_bands = 30;
num_paths = 1;

%% Extract the band structure and plot it
% Read the appropriate eigen energie values from EIGENVAL
[status,cmdout] = system('awk ''NR>6 && NF==2 { print $1,$2 }'' EIGENVAL');
if status
    error(['Akw encountered an error: ' num2str(status) '.'])
end

if ~isempty(strfind(cmdout,'***'))
    warning('More than 999 bands, indexing might be off!')
    cmdout = strrep(cmdout,'***','1000');
end

bands_temp = str2num(cmdout); %#ok<ST2NM>
num_bands = max(bands_temp(:,1));
num_k = length(bands_temp)/num_bands;
num_k_per_path = num_k/num_paths;
bands = reshape(bands_temp(:,2),[num_bands num_k]);

e_min = min(bands_temp(1:bands_to_plot,2));
e_max = max(bands_temp(1:bands_to_plot,2));

%% Read the k-points
[status,cmdout] = system('awk ''NR>6 && NF==4 { print $1,$2 }'' EIGENVAL');
if status
    error(['Akw encountered an error: ' num2str(status) '.'])
end
k_points = str2num(cmdout); %#ok<ST2NM>
k = sqrt(k_points(:,1).^2+k_points(:,2).^2);

%% Read the fermi energy from the OUTCAR file
[status,cmdout] = system('grep E-fermi OUTCAR | awk ''{print $3}''');
if status
    error(['grep or akw encountered an error: ' num2str(status) '.'])
end
fermi = str2double(cmdout);

clear status cmdout bands_temp

%% Plot the bands

% figure
% plot(1:num_k-2,bands(1:end,[1:num_k_per_path num_k_per_path+2:2*num_k_per_path 2*num_k_per_path+2:end]),'b')
% ylabel('Energy [eV]')
% hold all
% plot(1:num_k-2,ones(1,num_k-2)*fermi,'g')
% plot([num_k/3 num_k/3],[e_min e_max],'k')
% plot([num_k/3*2 num_k/3*2],[e_min e_max],'k')

% savefig('bandstructure.fig')
plot_inds = [1];
for ii =1:num_paths
    plot_inds = [plot_inds (ii-1)*num_k_per_path+2:ii*num_k_per_path];
end

figure
plot(1:num_k-num_paths+1,bands(1:wannier_bands,plot_inds),'b')
ylabel('Energy [eV]')
hold all
% plot(1:num_k-num_paths+1,bands(wannier_bands:bands_to_plot,plot_inds),'r')
plot(1:num_k-num_paths+1,ones(1,num_k-num_paths+1)*fermi,'g')
% for ii=1:num_paths-1
%     plot([ii*num_k/num_paths-ii+1 ii*num_k/num_paths-ii+1],[e_min e_max],'k')
% end
savefig('bandstructure_talk.fig')

clear num_bands num_k bands fermi e_min e_max k k_points num_valence_bands plot_num_bands top_valence_band
function[ ] = plotBandstructure()
% Reads the bandstructure from the EIGENVAL file and plots it.
% The paths are reconstructed using information from the KPOINTS file. It
% should also have a comment line (first line) of the form:
% Title of the plot G - M - H
% Where the high symmetry points are separated by -
% Other wise the labeling of the plot will not work correctly.

%% Read the appropriate eigen energie values from EIGENVAL
[ k,eig ] = read_eigenval();
[num_bands,num_k] = size(eig);
e_min = min(eig(:));
e_max = max(eig(:));

%% Get the paths
fid = fopen('KPOINTS');
buff = fgets(fid);
% if the comment has the wrong format, the labels will be off
points = strtrim(strsplit(buff,'-'));
t = points{1}(1:end-1);
points{1} = points{1}(end);

num_k_per_path = fscanf(fid,'%f');
num_paths = length(k)/num_k_per_path;
fclose(fid);

%% Ready the kpoints for plotting
dk = zeros(size(k));
dk(:,2:end) = k(:,2:end)-k(:,1:end-1);
dk = sqrt(sum(dk.^2,1));
k_p = zeros(1,length(k));
for kk = 2:length(k)
    k_p(kk) = k_p(kk-1)+dk(kk);
end

%% Generate the xticks
xtick_k = [k_p(1:num_k_per_path:end) k_p(end)];

%% Read the fermi energy from the OUTCAR file
[status,cmdout] = system('grep E-fermi OUTCAR | awk ''{print $3}''');
if status
    error(['grep or akw encountered an error: ' num2str(status) '.'])
end
fermi = str2double(cmdout);

%% Plot the bands

if num_paths==1
    figure
    plot(k_p,eig,'b.')
else
    figure
    plot(k_p,eig,'b.')
    hold all
    plot(k_p,ones(1,length(k_p))*fermi,'g')
    for ii=1:num_paths-1
        plot([k_p(ii*num_k/num_paths) k_p(ii*num_k/num_paths)],[e_min e_max],'k')
    end
    h = gca;
    h.XTick = xtick_k;
    h.XTickLabel = points;
    xlim([xtick_k(1) xtick_k(end)]);
    title(t)
end
ylim([e_min e_max])
ylabel('Energy [eV]')
savefig('bandstructure.fig')

end
function [ me, mh ] = effective_mass_vasp( np )
%EFFECTIVE_MASS Summary of this function goes here
%   Detailed explanation goes here

% get the length of the cell in real space
[~, ~, vecs] = read_contcar('POSCAR');
a = vecs(3,3)*1e-10;

% read the k-points
kid = fopen('KPOINTS');
line = strsplit(strtrim(fgets(kid)));
num_paths = length(line(3:2:end));
num_k_p_path = str2double(fgets(kid));
if ~(strcmp(fgetl(kid),'Line-mode') && strcmp(fgetl(kid),'rec'))
    fclose(kid);
    error('Wrong shape of the k-mesh')
end
% read the end points of the paths
p = zeros(2*num_paths,3);
for ii = 1:2:num_paths*2
    buff = fgetl(kid);
    p(ii,:) = sscanf(buff,'%f %f %f');
    buff = fgetl(kid);
    p(ii+1,:) = sscanf(buff,'%f %f %f');
    fgetl(kid);
end
fclose(kid);
% get the bandstructure and k-points
[k,E] = read_eigenval();
% sort the energies (they should be sorted alredy by VASP)
E = sort(E,1,'ascend');
% reduce the k vector to one dimension
[kz,dkz] = generate_k_path([p(1,:); p(2:2:end,:)]',num_k_p_path);
k_plot = cumsum(dkz);

if num_k_p_path*num_paths ~= length(k)
    error('The dimensions of the KPOINTS and EIGENVAL do not match!')
end

% remove the duplicate k-points from E
E(:,num_k_p_path+1:num_k_p_path:end) = nan;
E = E(:,~isnan(E(1,:)));

% find the bandgap
[~, Eg] = system('grep -i E-Fermi OUTCAR');
Eg = sscanf(Eg,'%*s %*s %f');
% count the number of valence bands
nvb = sum(E(:,1)<Eg);

figure
plot(k_plot,E,'ob','MarkerSize',3)
E_edge = E([nvb nvb+1],:);
hold on
plot(k_plot,E_edge,'o-r','MarkerSize',3)
hold off

% [me,ind_e] = effective_mass(kz*2*pi/a,E_edge(2,:));
% [mh,ind_h] = effective_mass(kz*2*pi/a,E_edge(1,:),'h');

me = effective_mass_at_k(kz*2*pi/a,E_edge(2,:),30,'back');
mh = effective_mass_at_k(kz*2*pi/a,E_edge(1,:),30,'back','h');

figure
[ke,Ek] = parabolic_band(me,a);
plot(k_plot,E_edge(2,:)-min(E_edge(2,:)),'o-r','MarkerSize',3)
hold on
plot(ke/(2*pi)*a+k_plot(ind_e),Ek,'b');
ylim([0 max(E_edge(2,:)-min(E_edge(2,:)))])

figure
[kh,Ek] = parabolic_band(mh,a);
plot(k_plot,E_edge(1,:)-max(E_edge(1,:)),'o-r','MarkerSize',3)
hold on
plot(kh/(2*pi)*a+k_plot(ind_h),-Ek,'b');
ylim([-max(E_edge(1,:)-min(E_edge(1,:))) 0])

end


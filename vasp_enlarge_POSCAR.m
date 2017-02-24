function [a, B_sc, id, nr_atoms, nr_unit_cells ] = vasp_enlarge_POSCAR(nx,ny,nz, shift,filename)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[B,Ap,a,N,T,id,crystal] = read_poscar(filename);

if ~crystal
    vasp_cart2dir(filename);
    [B,Ap,a,N,T,id,crystal] = read_poscar(filename);
end
% shif_lenght

replicas = [];

%replications
rx = nx-1;
ry = ny-1;
rz = nz-1;

%Nr of unit cells
nr_unit_cells = (rx+1)*(ry+1)*(rz+1);

%Nr of each atom type
nr_atoms = nr_unit_cells*N;

%shift the primitive cell if wanted

Ap(1,:) = Ap(1,:) + shift(1);
Ap(2,:) = Ap(2,:) + shift(2);
Ap(3,:) = Ap(3,:) + shift(3);

if (sum(sum(Ap>1 | Ap < 0)) == size(Ap,1)*size(Ap,2));
    disp('Some entries are shifted outside the unit cell and will be reentered from the opposite side.')
    Ap = Ap - floor(Ap);
end

%Generate coordinates of new lattice in the old lattice vectors
for l = 1:length(Ap(1,:));
    bottom = [];
    for i = 0:rx;
        bottom(i+1,:) = Ap(:,l)' + i*[1,0,0];
    end
    clear i;
    
    nr = size(bottom,1);
    
    for j = 1:nr
        for k = 1:ry
            entry = nr+(j-1)*ry+k;
            bottom(entry,:) = bottom(j,:) + k*[0,1,0];
        end
    end
    clear j k;
    nr = size(bottom,1);
    
    for j = 1:nr
        for k = 1:rz
            entry = nr+(j-1)*ry+k;
            bottom(entry,:) = bottom(j,:) + k*[0,0,1]';
        end
    end
    clear j k;
    
    replicas = [replicas; bottom];
end

%generate the lattice vectors of the super cell
B_sc = B*diag([rx+1, ry+1, rz+1]);

%Turn coordinates of sc into coordinates of the new basis

replicas = replicas*diag([1/(rx+1), 1/(ry+1),1/(rz+1)]);


fid = fopen([filename num2str(nx) 'x' num2str(ny) 'x' num2str(nz),],'w');
fprintf(fid,'%s\n', 'system');
fprintf(fid,'%f\n',a);
for i = 1:length(B_sc(:,1))
    fprintf(fid,'%.16f %.16f %.16f \n', B_sc(:,i));
    
end

for i = 1:length(id(1,:))
    fprintf(fid,'%s ',id{1,i});
end
fprintf(fid,'\n');
fclose(fid)

dlmwrite([filename num2str(nx) 'x' num2str(ny) 'x' num2str(nz),],nr_atoms,'-append','delimiter',' ');

fopen([filename num2str(nx) 'x' num2str(ny) 'x' num2str(nz),],'a+');
fprintf(fid,'%s \n','direct');
for i = 1:length(replicas(:,1));
    fprintf(fid,'%.16f %.16f %.16f \n', replicas(i,:));
    %fprintf(fid,'%s \n', 'T T F');
    
end

fclose(fid);





end
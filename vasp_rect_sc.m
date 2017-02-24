filename = 'CONTCAR_cor2x2x1'

[B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar(filename);

if crystal
    vasp_dir2cart(filename);
    [B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar(filename);
end

%Define base for supercell
B_sc = [(B(:,1)+B(:,2))/2 (-B(:,1)+B(:,2))/2 2*B(:,3)];

%Shift the new origin to (0,0,0)
S = B(:,1)/2;
Ap_pre_sc = Ap-repmat(S,1,size(Ap,2));

%Max coords
ori = [0 0 0]';
cor = B_sc(:,1) + B_sc(:,2) + B_sc(:,3);



%Check if atoms are inside the SC
Ap_in_sc = zeros(7,size(Ap,2));

for i =1:3
   Ap_in_sc(i,:) =  (Ap_pre_sc(i,:) >= 0);
end

for j = 1:3
    Ap_in_sc(3+j,:) = (Ap_pre_sc(j,:) <= cor(j));
%Ap_pre_sc = Ap
end

%Chec how many atoms are in the SC
b_border = sum(Ap_in_sc(7,:));



%Check if there are atoms on the border
tol = 1e-10;

for i = 1:3
    for j = 1:length(Ap)
        if (Ap_in_sc(i,j) == 0) && (Ap_pre_sc(i,j) > -tol)
           Ap_in_sc(i,j) = 1 ;
           Ap_pre_sc(i,j) = 0;
           
        end    
    end
end


for i = 1:3
    for j = 1:length(Ap)
        if (Ap_in_sc(i,j) == 0) && (Ap_pre_sc(i,j) < cor(i) + tol)
           Ap_in_sc(3+i,j) = 1 ;
           Ap_pre_sc(i,j) = cor(i); 
        end    
    end
end


%Check number of atoms in SC again
for j = 1:size(Ap,2)
    if sum(Ap_in_sc(:,j)) == 6
        Ap_in_sc(7,j) = 1;
    end
end

for j = 1:size(Ap,2)
    if sum(Ap_in_sc(:,j)) == 6
        Ap_in_sc(7,j) = 1;
    end
end

%See if atoms where added on the borders
a_border = sum(Ap_in_sc(7,:))
if a_border > b_border
    disp('There where atoms added on the borders')
end



%Create new POSCAR

nr_atoms = sum(Ap_in_sc(7,:));

Ap_sc = zeros(3,nr_atoms);
T_sc = zeros(1,nr_atoms);
dyn_tag_sc = char(ones(3,nr_atoms)*'T');

pos = 1;
for i = 1:size(Ap,2)
    if Ap_in_sc(7,i) == 1
        Ap_sc(:,pos) = Ap_pre_sc(:,i);
        T_sc(pos) = T(i);
        dyn_tag_sc(:,pos) = dyn_tag(:,i);
        pos = pos +1;
    end
end

N_sc = zeros(1,length(N));
for i = 1:length(N)
   N_sc(i) = sum(T_sc(:) == i);
end    

vasp_write_poscar(B_sc,Ap_sc,a,N_sc,id,crystal, sel_dyn, dyn_tag_sc, [filename '_sc'])


scatter3(a*Ap_sc(1,:),a*Ap_sc(2,:),a*Ap_sc(3,:),20,'b','filled')

clear all

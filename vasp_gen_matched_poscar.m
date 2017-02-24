%Preconditions on POSCARs
    %Should have the same unit_cell
    %atoms should be as close togeter as possible. i.e. a layer should be
    %grouped as a layer and not as two sheets plus an additional sheet that
    %basically belongs to the negst layer.


filename = 'POSCAR_MoTe2';
filename1 = 'POSCAR_MoSe2';

Max = 10; 
tol = 0.20;
prop = 1;
dist = 3.714787615339735;

turn = [0 0 0];

%Importing the data of the two crystals to be added.
[B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar(filename);
[B1,Ap1,a1,N1,T1,id1,crystal1,sel_dyn1, dyn_tag1] = vasp_read_poscar(filename1);

if(crystal == 0)
    Ap = inv(B)*Ap
end  

if(crystal1 == 0)
    Ap1 = inv(B1)*Ap1
end

%Reasure that the basis vectors have the same length

if sum(sum(B==B1)) == 9;
    disp('Basis matrixes equivalent')
else
    disp('Basis matrix not equivalent')
    disp(['Calibrate the matrix by hand. The scripts' ...
          'vasp_dir2cart.m and vasp_cart2dir.m are ' ...
          'helpful for this.'])
    clear all
    return
end


%Get the smallest match for strained unit cell consts a_new1 and a_new2
[smallest_match, a_new, a_new1] = match_lat_consts(a,a1,Max,tol,prop);


nr_atoms = smallest_match(1,1)^2*size(Ap,2)+smallest_match(1,2)^2*size(Ap,2);

fprintf('The number of atoms in the supercell will be %i.\n', nr_atoms)
t = input('Do you want to continue? [y/n]:','s');
if t=='n'
    return
end



%test
if (a_new*smallest_match(1,1) - a_new1*smallest_match(1,2) > 10^-7)
    disp('SOMETHING IS WRONG WITH THE MATCHING')
    return
end


%create new strained poscar
vasp_write_poscar(B,Ap,a_new,N,id,crystal, sel_dyn, dyn_tag, [filename '_strained']);
vasp_write_poscar(B1,Ap1,a_new1,N1,id1,crystal1, sel_dyn1, dyn_tag1, [filename1 '_strained']);


%shift lattice 1 to zero in z-direction and lattice 2 to max(z) lattice 1 plus a certain
%distance.
[B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar([filename '_strained']);
[B1,Ap1,a1,N1,T1,id1,crystal1,sel_dyn1, dyn_tag1] = vasp_read_poscar([filename1 '_strained']);

shift_z = [0 0 min(Ap(3,:))*B(3,3)*a];
vasp_cart_shift_poscar(-shift_z,[filename '_strained'],[filename '_strained']);

%Shift completely down to zero and then up to thickness layer1 + dist
shift_z1 = [0 0 min(Ap1(3,:))*B1(3,3)*a1-(max(Ap(3,:))-min(Ap(3,:)))*B(3,3)*a-dist]; 
vasp_cart_shift_poscar(-shift_z1,[filename1 '_strained'],[filename1 '_strained']);

%Move the lowest atom of the lattices to the origin of the xy-plane
[~, ind_min] = min(Ap(3,:));
shift = [Ap(1:2,ind_min)' 0];
vasp_dir_shift_poscar(-shift,[filename '_strained'],[filename '_strained']);

[~, ind_min1] = min(Ap1(3,:));
shift = [Ap1(1:2,ind_min1)' 0]+turn;
vasp_dir_shift_poscar(-shift,[filename1 '_strained'],[filename1 '_strained']);



%use the strained 

vasp_enlarge_POSCAR(smallest_match(1,1),smallest_match(1,1),1, [0 0 0],[filename '_strained']);
vasp_enlarge_POSCAR(smallest_match(1,2),smallest_match(1,2),1, [0 0 0],[filename1 '_strained']);

enlarged = [[filename '_strained'] [num2str(smallest_match(1,1)) 'x' num2str(smallest_match(1,1)) 'x1']];
enlarged1 = [[filename1 '_strained'] [num2str(smallest_match(1,2)) 'x' num2str(smallest_match(1,2)) 'x1']];



%Read the enlarged POSCAR and add them into a single file
[B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar(enlarged);
[B1,Ap1,a1,N1,T1,id1,crystal1,sel_dyn1, dyn_tag1] = vasp_read_poscar(enlarged1);

if(crystal == 1)
    vasp_dir2cart(enlarged);
    [B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar(enlarged);
end  

if(crystal1 == 1)
    vasp_dir2cart(enlarged1);
    [B1,Ap1,a1,N1,T1,id1,crystal1,sel_dyn1, dyn_tag1] = vasp_read_poscar(enlarged1);
end


B_new = B;
Ap_new = [Ap Ap1.*(a1/a)];
a_new = a;
N_new = [N N1];
T_new = [T T1+length(unique(T))];
id_new = [id id1];
crystal_new = 0;
sel_dyn_new = 1;
dyn_tag_new = [dyn_tag dyn_tag1];


vasp_write_poscar(B_new,Ap_new,a_new,N_new,id_new,crystal_new, sel_dyn_new, dyn_tag_new, 'POSCAR');

system('mkdir intermediate_results');
system(['mv ' [filename '_strained '] [filename1 '_strained '] ' ' enlarged ' ' enlarged1 ' intermediate_results'  ]);

vasp_calc_layer_thickness('POSCAR')
clear all;
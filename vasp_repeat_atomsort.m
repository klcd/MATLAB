[B,Ap,a,N,T,id,crystal] = read_poscar();

atom2shift = 'Pt';
shift = [0 0 0.15];


%Seperating the coordinates according to the different atomsorts.
for i =1:length(id)
    Aps.(id{i}) = [];
end

for i = 1:length(T)
    Aps.(id{T(i)}) = [Aps.(id{T(i)}) Ap(:,i)];   
end


%Shifting the specified atomsort atom2shift by shift
Aps.(atom2shift) = [Aps.(atom2shift) Aps.(atom2shift)+repmat(shift',1,length(Aps.(atom2shift)))];

%New number of atoms
N_new = zeros(1,length(N));
for i = 1:length(id)
    N_new(i) = length(Aps.(id{i}));
end

%Appending the new atomlists correctly
Ap_new = [];
for i = 1:length(id)
    Ap_new = [Ap_new Aps.(id{i})];
end

%Entries outside unit cell
[row,col] = find(~(0 <= Ap_new & Ap_new <= 1))

if(length(row)>0)
    disp('There are entries that are outside the unit cell.')
    disp('Think about if you want to correct this or to enlarge')
    disp('the unit cell.')


%write the new POSCAR
write_poscar(B,Ap_new,a,N_new,id,crystal,'test')




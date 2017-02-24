function [ mina ,minc, mine, p ] = lattice_sweep( n_core, command, a, na, da, c, nc, dc )
% lattice_sweep runs a sweep over two lattice constants with vasp
% Sweeps the specified lattice constants and fits the data to a polynomial.
%   INPUT
%   n_core: number of cpus to run vasp on
%   command: command to tun vasp
%   a: first lattice constant
%   na: number of points from a in one direction
%   da: difference between to a values
%       a will take 2*na+1 values from a-na*da to a+na*da
%   c: second lattice constant
%   nc: as na
%   dc: as da
%   OUTPUT
%   mina: is the minimum of the first lattice constant
%   minc: as mina for the second one
%   mine: computed energy value in the minimum
%   p: contains the coefficients for the paraboloid fitting the energy data
%       p(1)*a^2+p(2)*a+p(3)*c+p(4)*c^2+c(5) = energy(a,c)


% initialise the vectors
a_grid = a-na*da:da:a+na*da;
c_grid = c-nc*dc:dc:c+nc*dc;

energy = zeros(length(a_grid),length(c_grid));

% save the current POSCAR
copyfile('POSCAR','POSCAR_original');

% loop over all combinations
for aa = 1:length(a_grid)
    
    disp(['a = ' num2str(a_grid(aa))])
    
    for cc = 1:length(c_grid)
        
%         disp(['c = ' num2str(c_grid(cc))])
        
        % Modify the POSCAR
        awk_cmd = ['awk ''NR == 2 {$0=' num2str(a_grid(aa)) '} NR == 5 {$3=' ...
            num2str(c_grid(cc)/a_grid(aa)) '}1'' POSCAR > POSCAR_temp'];
        system(awk_cmd);
        copyfile('POSCAR_temp','POSCAR');
        
        % run the simulation
        system(['intelrun -n ' num2str(n_core) ' ' command ' > output </dev/null']);
        
        [~,e] = system('grep sigma- OUTCAR');
        e = strsplit(e,'=');

        energy(aa,cc) = sscanf(e{end},'%f',1);
        
    end
end

copyfile('POSCAR_original','POSCAR');
delete('POSCAR_temp','POSCAR_original');
% plot the data
figure
surf(a_grid,c_grid,energy');
xlabel a
ylabel c
zlabel energy
grid on

% fit the data to a paraboloid using least squares

a_x = reshape(repmat(a_grid,length(c_grid),1),[],1);
c_y = reshape(repmat(c_grid',length(a_grid),1),[],1);
e_z = reshape(energy',[],1);

A = [a_x.^2 a_x a_x.*c_y c_y c_y.^2 ones(size(a_x))];

p = A\e_z;

mina = -p(2)/p(1)*0.5;
minc = -p(4)/p(5)*0.5;

mine = [mina^2 mina mina*minc minc minc^2 1]*p;

a = a_grid;
c = c_grid;

save('sweep.mat','a','c','energy');

end
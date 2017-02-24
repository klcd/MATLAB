function [  ] = read_outcars(  )
%READ_CONTCAR Summary of this function goes here
%   Detailed explanation goes here
coords = read_contcar('../POSCAR');
num_atoms = 0;
for ii=1:length(coords)
    num_atoms = num_atoms + coords{ii,2};
end

[~,str]=unix('sed -n ''/POSITION/,/total drift/{/POSITION/b;/total drift/b;p}'' ../OUTCAR');
str = strrep(str,'-----------------------------------------------------------------------------------','');

pos = str2num(str); %#ok<ST2NM>
forces = pos(:,4:6);
pos = pos(:,1:3);

coords = read_contcar('POSCAR');
num_atoms_2 = 0;
for ii=1:length(coords)
    num_atoms_2 = num_atoms_2 + coords{ii,2};
end

if num_atoms ~= num_atoms_2
    error('The two POSCAR files are incompatible')
end

[~,str]=unix('sed -n ''/POSITION/,/total drift/{/POSITION/b;/total drift/b;p}'' OUTCAR');
str = strrep(str,'-----------------------------------------------------------------------------------','');

pos2 = str2num(str); %#ok<ST2NM>
forces = [forces; pos2(:,4:6)];
pos = [pos; pos2(:,1:3)];

num_steps = length(pos)/num_atoms

figure
plot(pos(num_atoms-12:num_atoms:end,3))
title('First boron layer')
figure
plot(pos(num_atoms-8:num_atoms:end,3))
title('Second boron layer')

figure
plot(pos(num_atoms-15:num_atoms:end,3))
title('Sixth gold layer')
figure
plot(pos(num_atoms-18:num_atoms:end,3))
title('Seventh gold layer')

figure
plot(forces(num_atoms-12:num_atoms:end,3))
title('First boron layer, force')
figure
plot(forces(num_atoms-8:num_atoms:end,3))
title('Second boron layer, force')

figure
plot(forces(num_atoms-15:num_atoms:end,3))
title('Sixth gold layer, force')
figure
plot(forces(num_atoms-18:num_atoms:end,3))
title('Seventh gold layer, force')

end


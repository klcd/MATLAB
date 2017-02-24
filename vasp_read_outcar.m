function [ ] = vasp_read_outcar(  )
%READ_CONTCAR Summary of this function goes here
%   Detailed explanation goes here

[~,coords,~] = read_contcar('POSCAR');
num_atoms = 0;
[len,~] = size(coords);
for ii=1:len
    num_atoms = num_atoms + coords{ii,2};
end

[~,str]=unix('sed -n ''/POSITION/,/total drift/{/POSITION/b;/total drift/b;p}'' OUTCAR');
str = strrep(str,'-----------------------------------------------------------------------------------','');

pos = str2num(str); %#ok<ST2NM>
forces = pos(:,4:6);
pos = pos(:,1:3);

num_steps = length(pos)/num_atoms;

% figure
% plot(1:num_steps,reshape(pos(:,1),[],num_steps)-repmat(pos(1:num_atoms,1),1,num_steps),'x-')
% title('position x direction')
% 
% figure
% plot(1:num_steps,reshape(pos(:,2),[],num_steps)-repmat(pos(1:num_atoms,2),1,num_steps),'x-')
% title('position y direction')

figure
plot(1:num_steps,reshape(pos(:,3),[],num_steps)-repmat(pos(1:num_atoms,3),1,num_steps),'x-')
title('position z direction')

% figure
% plot(1:num_steps,reshape(forces(:,1),[],num_steps)','x-')
% title('force x direction')

% figure
% plot(1:num_steps,reshape(forces(:,2),[],num_steps)','x-')
% title('force y direction')

figure
plot(1:num_steps,reshape(forces(:,3),[],num_steps)','x-')
title('force z direction')



end


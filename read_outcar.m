function [ ] = read_outcar(  )
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

figure
plot(1:num_steps,reshape(pos(:,1),[],num_steps)-repmat(pos(1:num_atoms,1),1,num_steps))
title('position x direction')
% 
% figure
% plot(1:num_steps,reshape(pos(:,2),[],num_steps)-repmat(pos(1:num_atoms,2),1,num_steps))
% title('position y direction')

figure
plot(1:num_steps,reshape(pos(:,3),[],num_steps)-repmat(pos(1:num_atoms,3),1,num_steps))
title('position z direction')

% figure
% plot(1:num_steps,reshape(forces(:,1),[],num_steps)')
% title('force x direction')
% 
% figure
% plot(1:num_steps,reshape(forces(:,2),[],num_steps)')
% title('force y direction')

figure
plot(1:num_steps,reshape(forces(:,3),[],num_steps)')
title('force z direction')

% figure
% hold on
% plot(forces(num_atoms-16:num_atoms:end,3))
% plot(forces(num_atoms-7:num_atoms:end,3))
% plot(forces(num_atoms-4:num_atoms:end,3))
% plot(forces(num_atoms:num_atoms:end,3))
% title('forces on hBN layers, from top:')
% legend('2nd B','1st B','2nd N','1st N','location','southwest')
% grid on
% % ylim([-0.005 0.005])
% 
% % figure
% % hold on
% % plot(abs(forces(num_atoms-9:num_atoms:end,3)))
% % plot(abs(forces(num_atoms-6:num_atoms:end,3)))
% % plot(abs(forces(num_atoms-3:num_atoms:end,3)))
% % plot(abs(forces(num_atoms:num_atoms:end,3)))
% % title('Abs. of the forces on gold layers, from top:')
% % legend('4th','3rd','2nd','1st')
% % grid on
% 
% figure
% hold on
% plot(pos(num_atoms-16:num_atoms:end,3)-pos(num_atoms-16,3));
% plot(pos(num_atoms-7:num_atoms:end,3)-pos(num_atoms-7,3));
% plot(pos(num_atoms-4:num_atoms:end,3)-pos(num_atoms-4,3));
% plot(pos(num_atoms:num_atoms:end,3)-pos(num_atoms,3));
% title('Atom displacement, relative to the start.')
% legend('2nd B','1st B','2nd N','1st N','location','southwest')
% grid on

% d_au = pos(4,3)-pos(1,3);
% 
% figure
% plot(pos(num_atoms-12:num_atoms:end,3))
% legend('First boron layer')
% figure
% plot(pos(num_atoms-8:num_atoms:end,3))
% legend('Second boron layer')
% 
% figure
% plot(1:num_steps,[pos(num_atoms-13:num_atoms:end,3) pos(num_atoms-14:num_atoms:end,3) pos(num_atoms-15:num_atoms:end,3)])
% title('Seventh gold layer')
% figure
% plot(1:num_steps,[pos(num_atoms-16:num_atoms:end,3) pos(num_atoms-17:num_atoms:end,3) pos(num_atoms-18:num_atoms:end,3)])
% title('Sixth gold layer')
% figure
% plot(forces(num_atoms-12:num_atoms:end,3))
% hold on
% plot(forces(num_atoms-8:num_atoms:end,3))
% legend('First boron layer, force','Second boron layer, force')
% ylim([-5e-3 5e-3])
% 
% figure
% plot(forces(num_atoms-16:num_atoms:end,3))
% hold on
% plot(forces(num_atoms-19:num_atoms:end,3))
% legend('Seventh gold layer, force','Sixth gold layer, force')
% ylim([-5e-3 5e-3])

end
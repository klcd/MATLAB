function [] = optics_plot_oscillator_strengths(val,con,dir)
%Returns a 3D-Plot of the oscillator strengts in the irreducible brioullin
%zone. Parameters are the following:
%   val: Valence band considered as seen from fermilevel.
%   con: Conduction band considered as seen from fermilevel.
%   dir: Direction of the matrix element tensor. Where 
%           1:x;  2:y; 3:z; 4:xy; 5:xz; 6:yz;
            
load optics.mat

val = nr_val + 1 -val;              
dirs = {'x' 'y' 'z' 'xy' 'xz' 'yz'};


dat = os_str(:,:,con,val);

name = cell(nr_kpt,1);

for i = 1:nr_kpt
    name{i,1} = [atom{val,i} ' to ' atom{val+con,i}];
    
end

All_name = unique(name);
name_nr = zeros(nr_kpt,1);
c = hsv(4*length(All_name));
%figure
h = zeros(1,length(All_name));
for i = 1:length(All_name)
    take = strcmp(name,All_name{i});
    name_nr(take,1) = i; 
    hold on
    h(i) = plot3(Kpts(take,1),Kpts(take,2),dat(take,dir),'x');
    %h(i) = plot3(Kpts(take,1),Kpts(take,2),dat(take,dir),'bo');
    set(h(i),'Color',c(4*i,:))
    hold off
end
title(['Absorption from VB ' num2str(nr_val-val+1) ' to CB ' num2str(con) ' in direction ' dirs{dir} ]) 
legend(All_name);

end
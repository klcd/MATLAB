function [ ] = bias_point( V, Ef, num_layers_1, num_layers_2, num_layers_3 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

vid = fopen('vact_dat','w');
V = -V;
pot = [zeros(1,num_layers_1-1) linspace(0,V,num_layers_2+2) ones(1,num_layers_3-1)*V];
fprintf(vid,'%f\n',pot);

fclose(vid);

eid = fopen('E_dat','w');

if V > 0;
    energy = Ef-0.2:0.05:Ef+V+0.2;
else
    energy = Ef+V-0.2:0.05:Ef+0.2;
end
% energy = linspace(Ef+V-0.2,Ef+0.2,31);
fprintf(eid,'%d\n',length(energy));
fprintf(eid,'%.5f\n',energy);
fclose(eid);

end


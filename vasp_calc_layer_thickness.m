function [conf] = vasp_calc_layer_thickness(filename)
%Calculates the longest distance between two atoms inside the unit cell in z-direction.

%% default argument
if nargin<1
    filename = 'POSCAR';
end

[B1,Ap1,a1,~,~,~,crystal1,~, ~] = vasp_read_poscar(filename);

Lz1 = B1(3,3)*a1;

if crystal1 == 1
        conf = B1(3,3)*(max(Ap1(3,:))-min(Ap1(3,:)))*a1;
else
        conf = (max(Ap1(3,:))-min(Ap1(3,:)))*a1;
end

if conf/Lz1 > 0.5;
    disp('The layer thickness is larger than 50% of the unit cell volume.')
    disp('Either something is wrong in POSCAR or this is a bad choice for the')
    disp('unit cell')
end

end


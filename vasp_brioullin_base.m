function [Base] = vasp_brioullin_base(filename)
%Returns the Brioullin zone basis.

if nargin < 1
    filename = 'POSCAR';
end

[B,~,a,~,~,~,~,~,~] = vasp_read_poscar(filename);

Base = zeros(3,3);
Vol = sum(B(:,1).*cross(B(:,2),B(:,3)));
Base(:,1) = 2*pi/a*cross(B(:,2),B(:,3))/Vol;
Base(:,2) = 2*pi/a*cross(B(:,3),B(:,1))/Vol;
Base(:,3) = 2*pi/a*cross(B(:,1),B(:,2))/Vol;

end

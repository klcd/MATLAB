function [del] = in_cube(A,xx,yy,zz)
%Determines wether coordinates in A are inside a cube determined by two
%corners given in xx,yy,zz. Returns a list specifing if each point is
%inside or not. 
%A(:,del) : Points in cube.
%A(:,~del) : List of coords  in A without points in cube.

%  A: 3Xn matrix 
%  xx: 1x2 matrix : x-coordinates corners
%  yy: 1x2 matrix : y-coordinates corners
%  zz: 1x2 matrix : z-coordinates corners


%Coordinates of points inside POSCAR without scaling
xq = A(1,:);
yq = A(2,:);
zq = A(3,:);

xv = [xx(1) xx(2) xx(2) xx(1) xx(1)];
yv = [yy(1) yy(1) yy(2) yy(2) yy(1)];
zv = [zz(1) zz(2) zz(2) zz(1) zz(1)];

[in_xy,on_xy] = inpolygon(xq,yq,xv,yv);
[in_zy,on_zy] = inpolygon(yq,zq,yv,zv);


%If del(i) is 1 then the Ap(:,i) will be cut away from the POSCAR file
del = zeros(1,length(xq));
for i = 1:length(xq)
    del(i) = (in_xy(i) && in_zy(i)) || (on_xy(i) && on_zy(i)) ||(on_xy(i) && on_zy(i));
end

figure
plot(xv,yv) % polygon
axis equal

hold on
plot(xq(in_xy),yq(in_xy),'r+') % points inside
plot(xq(~in_xy),yq(~in_xy),'bo') % points outside
hold off

figure
plot(yv,zv) % polygon
axis equal

hold on
plot(yq(in_zy),zq(in_zy),'r+') % points inside
plot(yq(~in_zy),zq(~in_zy),'bo') % points outside
hold off



end


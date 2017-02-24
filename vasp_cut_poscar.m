%Cuts away all coordinates in a POSCAR that are inside a cube specified by
%the two corners xx = [x1 x2], yy = [y1 y2] and zz = [z1 z2]


filename = 'CONTCAR1x3x1'

[B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar(filename);

if crystal
    vasp_dir2cart(filename);
    [B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar(filename);
end

%Coordinates of points inside POSCAR without scaling
xq = Ap(1,:);
yq = Ap(2,:);
zq = Ap(3,:);

%Volume to cut out of POSCAR
xx = [-0.1 1];
yy = [max(Ap(2,:))*2/3-1e-6 4];
zz = [0.5 3];


del = in_cube(Ap,xx,yy,zz);

% xv = [xx(1) xx(2) xx(2) xx(1) xx(1)];
% yv = [yy(1) yy(1) yy(2) yy(2) yy(1)];
% zv = [zz(1) zz(2) zz(2) zz(1) zz(1)];
% 
% [in_xy,on_xy] = inpolygon(xq,yq,xv,yv);
% [in_zy,on_zy] = inpolygon(yq,zq,yv,zv);
% 
% 
% %If del(i) is 1 then the Ap(:,i) will be cut away from the POSCAR file
% 
% del = zeros(1,length(xq));
% for i = 1:length(xq)
%     del(i) = (in_xy(i) && in_zy(i)) || (on_xy(i) && on_zy(i)) ||(on_xy(i) && on_zy(i));
% end

% figure
% plot(xv,yv) % polygon
% axis equal
% 
% hold on
% plot(xq(in_xy),yq(in_xy),'r+') % points inside
% plot(xq(~in_xy),yq(~in_xy),'bo') % points outside
% hold off
% 
% figure
% plot(yv,zv) % polygon
% axis equal
% 
% hold on
% plot(yq(in_zy),zq(in_zy),'r+') % points inside
% plot(yq(~in_zy),zq(~in_zy),'bo') % points outside
% hold off

T_sc = T(~del);
Ap_sc = Ap(:,~del);
dyn_tag_sc = dyn_tag(:,~del);


N_sc = zeros(1,length(N));
for i = 1:length(N)
   N_sc(i) = sum(T_sc(:) == i);
end 

vasp_write_poscar(B,Ap_sc,a,N_sc,id,crystal, sel_dyn, dyn_tag_sc, [filename '_cut'])

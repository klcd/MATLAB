

nb_val = vasp_check_keyword('RUNINFO','NBVAL',1)
nb_con_use = vasp_check_keyword('RUNINFO','NBCON_USE',1)
scale_const = vasp_check_keyword('RUNINFO','CONST',1)

load ./EPS1
eps_xx = scale_const*EPS1(0*(nb_val*nb_con_use)+1:1*(nb_val*nb_con_use),:);
eps_yy = scale_const*EPS1(1*(nb_val*nb_con_use)+1:2*(nb_val*nb_con_use),:);
eps_zz = scale_const*EPS1(2*(nb_val*nb_con_use)+1:3*(nb_val*nb_con_use),:);
eps_xy = scale_const*EPS1(3*(nb_val*nb_con_use)+1:4*(nb_val*nb_con_use),:);
eps_xz = scale_const*EPS1(4*(nb_val*nb_con_use)+1:5*(nb_val*nb_con_use),:);
eps_yz = scale_const*EPS1(5*(nb_val*nb_con_use)+1:6*(nb_val*nb_con_use),:);

ep_xx = zeros(size(eps_xx));

for i = fliplr(2:size(eps_xx,1))
    ep_xx(i,:) = eps_xx(i,:) - eps_xx(i-1,:); 
end
ep_xx(1,:) = eps_xx(1,:);

ep_yy = zeros(size(eps_yy));

for i = fliplr(2:size(eps_yy,1))
    ep_yy(i,:) = eps_yy(i,:) - eps_yy(i-1,:); 
end
ep_yy(1,:) = eps_yy(1,:);

ep_zz = zeros(size(eps_zz));

for i = fliplr(2:size(eps_zz,1))
    ep_zz(i,:) = eps_zz(i,:) - eps_zz(i-1,:); 
end
ep_zz(1,:) = eps_zz(1,:);


ep_xy = zeros(size(eps_xy));

for i = fliplr(2:size(eps_xy,1))
    ep_xy(i,:) = eps_xy(i,:) - eps_xy(i-1,:); 
end
ep_xy(1,:) = eps_xy(1,:);

ep_xz = zeros(size(eps_xz));

for i = fliplr(2:size(eps_xz,1))
    ep_xz(i,:) = eps_xz(i,:) - eps_xz(i-1,:); 
end
ep_xz(1,:) = eps_xz(1,:);

ep_xz = zeros(size(eps_xz));

for i = fliplr(2:size(eps_yz,1))
    ep_yz(i,:) = eps_yz(i,:) - eps_yz(i-1,:); 
end
ep_yz(1,:) = eps_yz(1,:);


save('ep_xx.mat','ep_xx');
save('ep_yy.mat','ep_yy');
save('ep_zz.mat','ep_zz');
save('ep_xy.mat','ep_xy');
save('ep_xz.mat','ep_xz');
save('ep_yz.mat','ep_yz');







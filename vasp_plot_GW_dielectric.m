clear all;
fid1 = fopen('re_dielectric.dat');
C1 = textscan(fid1, '%f %f %f %f %f %f %f');

fid2 = fopen('im_dielectric.dat');
C2 = textscan(fid2, '%f %f %f %f %f %f %f');
[B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar();


% Lz = B(3,3)*a;
% 
% if crystal == 1
%     conf = B(3,3)*(max(Ap(3,:))-min(Ap(3,:)))*a;
% else
%     conf = (max(Ap(3,:))-min(Ap(3,:)))*a;
% end
% 
% 
% if conf > 0    
%     for i = 2:7
%         C1{i} = C1{i}*Lz/(conf);
%         C2{i} = C2{i}*Lz/conf;
%     end
% end

%figure
plot(C2{1},C2{3},'k-')
%axis([0 4.5, 0 80])
xlabel('\fontsize{15}Photon Energy [eV]')
ylabel('\fontsize{15}Im(\fontsize{20}{\epsilon}\fontsize{15} )')
%title('MoSe_2+WSe_2','Fontsize',20)
title('MoSe_2','Fontsize',20)
hold on
%plot(en,di,'ro')
%h_legend = legend( '7 kpoints','exp')
%set(h_legend,'FontSize',15)
%set(gca, 'Layer','top')

xlim([0,3])
clear all
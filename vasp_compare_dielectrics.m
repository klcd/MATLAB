%files = {'MoTe_2', 'WTe_2', 'MoTe_2 WTe_2'}
 files = {'MoS_2', 'WS_2', 'MoS_2 WS_2'}
% files = {'MoSe_2', 'WSe_2', 'MoSe_2 WSe_2'}

frachem1 = 2*pi/(4.135667662*2.99792458)*10^-3;

file1 = [files{1} '_impart'];
fid1 = fopen(file1);
im1 = textscan(fid1, '%f %f %f %f %f %f %f','headerLines',3);
fclose(fid1);

pos1 = [files{1} '_POSCAR'];
[B1,Ap1,a1,~,~,~,crystal1,~, ~] = vasp_read_poscar(pos1);
Lz1 = B1(3,3)*a1;
conf1 = vasp_calc_layer_thickness(pos1)


file2 = [files{2} '_impart'];
fid2 = fopen(file2);
im2 = textscan(fid2, '%f %f %f %f %f %f %f','headerLines',3);
fclose(fid2);

pos2 = [files{2} '_POSCAR'];
[B2,Ap2,a2,~,~,~,crystal1,~, ~] = vasp_read_poscar(pos2);
Lz2 = B2(3,3)*a2;
conf2 = vasp_calc_layer_thickness(pos2)

file3 = [files{3} '_impart']
fid3 = fopen(file3);
im3 = textscan(fid3, '%f %f %f %f %f %f %f','headerLines',3);
fclose(fid3);

pos3 = [files{3} '_POSCAR'];
[B3,~,a3,~,~,~,~,~, ~] = vasp_read_poscar(pos3);
Lz3 = B3(3,3)*a3;
conf3 = vasp_calc_layer_thickness(pos3)




x1 = im1{1};
x2 = im2{1};
x3 = im3{1};

y1 = im1{2}*Lz1;
y2 = im2{2}*Lz2;
y3 = im3{2}*Lz3

% y1 = frachem1*im1{1}.*im1{2}*Lz1;
% y2 = frachem1*im2{1}.*im2{2}*Lz2;
% y3 = frachem1*im3{1}.*im3{2}*Lz3;
% 
% y1 = 1-exp(-frachem1*im1{1}.*im1{2}*Lz1);
% y2 = 1-exp(-frachem1*im2{1}.*im2{2}*Lz2);
% y3 = 1-exp(-frachem1*im3{1}.*im3{2}*Lz3);


xx = 0:0.02:10;
yy1 = spline(x1,y1,xx);
yy2 = spline(x2,y2,xx);

add = yy1+yy2;

%figure
plot(xx,yy1,'y', xx,yy2,'g')
hold on
plot(xx,add,'r',x3,y3,'b')

% xlim([0 10])
% ylim([0 360])
% title(['\fontsize{20} Absorption in ' files{3}])
% xlabel('\fontsize{15} Photon Energy [eV]')
% ylabel('\fontsize{15} \epsilon ^{(2)}')

legend(files{1}, files{2}, 'Added', files{3},'Location','northwest')






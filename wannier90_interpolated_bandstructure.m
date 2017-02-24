fid = fopen('wannier90_geninterp.dat');

c = textscan(fid,'%f %f %f %f %f %f %f %f', 'headerLines',3);

nbands = sum(c{1,1}==1);
len = length(c{1,2});


for i = 6:1:nbands-2
    scatter3(c{1,2}(i:nbands:len,1),c{1,3}(i:nbands:len,1),c{1,5}(i:nbands:len,1),'.')
    hold on
end
hold off

% figure= 
% Inv_Int= ((c{1,6}(10:nbands:len,1) - c{1,6}(9:nbands:len,1)).^2 +(c{1,7}(10:nbands:len,1) - c{1,7}(9:nbands:len,1)).^2).^(1/2);
% scatter3(c{1,2}(1:nbands:len,1),c{1,3}(1:nbands:len,1),Inv_Int,5,Inv_Int)
% colormap(jet);
% colorbar

%matrix export for contour plot in mathematica
kx = c{1,2}(1:nbands:len,1);
ky = c{1,3}(1:nbands:len,1);

% diff = (c{1,5}(22:nbands:len,1) - c{1,5}(21:nbands:len,1));
% Inv_Int = sqrt((c{1,6}(22:nbands:len,1) - c{1,6}(21:nbands:len,1)).^2+(c{1,7}(22:nbands:len,1) - c{1,7}(21:nbands:len,1)).^2);
% 
% export_inv_int = [kx ky Inv_Int];
% dlmwrite('cp_Int.dat', export_inv_int,'delimiter',' ');
% 
% export_diff = [kx ky diff];
% dlmwrite('cp_diff.dat',export_diff,'delimiter',' ');


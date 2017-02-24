fid = fopen('wannier90_geninterp.dat');

c = textscan(fid,'%f %f %f %f %f %f %f %f %f', 'headerLines',3);

nbands = 11;
len = length(c{1,2});

figure
for i = 7:1:nbands
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
diff = (c{1,5}(10:nbands:len,1) - c{1,5}(9:nbands:len,1));
%export_inv_int = [kx ky Inv_Int];
%dlmwrite('cp_Int.dat', export_inv_int,'delimiter',' ');

%export_diff = [kx ky diff];
%dlmwrite('cp_diff.dat',export_diff,'delimiter',' ');


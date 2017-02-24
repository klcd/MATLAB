function [ crystalEnergy ] = latticeEnergy( param )
%LATTICEENERGY Summary of this function goes here
%   Detailed explanation goes here
a = param(1);
c = param(2);

fid = fopen('POSCAR','r');
text = fileread('POSCAR');
fgetl(fid);
line = fgetl(fid);
text = strrep(text,line,num2str(a));

fgetl(fid); fgetl(fid);
temp = textscan(fgetl(fid),'%f');
c_old = num2str(temp{1}(3));
text = strrep(text,c_old,num2str(c/a));
fclose(fid);

fid = fopen('POSCAR','w');
fprintf(fid,text);
fclose(fid);

unix('mpiexec -n 4 ~/Desktop/vasp-5.3-sse4.2 > output </dev/null');
text = fileread('OUTCAR');
ind = strfind(text,'(sigma->0) =')+18;

crystalEnergy = str2double(text(ind(end):ind(end)+12));
end


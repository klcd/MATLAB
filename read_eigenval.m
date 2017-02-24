function [ k,eig ] = read_eigenval( file_name )
%READ_EIGENVAL Summary of this function goes here
%   Detailed explanation goes here

if nargin > 0
    fid = fopen(file_name);
else
    fid = fopen('EIGENVAL');
end

for ii=1:5
    fgetl(fid);
end
tmp = str2num(fgetl(fid)); %#ok<*ST2NM>
num_k = tmp(2); num_band = tmp(3);

k = zeros(3,num_k);
eig = zeros(num_band,num_k);

for kk = 1:num_k
    fgetl(fid);
    buff = str2num(fgetl(fid));
    k(:,kk) = buff(1:3);
    data = textscan(fid,'%*s%f',num_band);
    eig(:,kk) = data{1};
    fgetl(fid);
end

end


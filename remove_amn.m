function [ ] = remove_amn( file_name, num_target_bands )
%CUT_EIG Summary of this function goes here
%   Detailed explanation goes here

if nargin < 1
    file_name = 'wannier90.amn';
end

fid = fopen(file_name);
wid = fopen([file_name(1:end-4) '_' num2str(num_target_bands) 'bands.amn'],'w');
buff = fgets(fid);
fwrite(wid,buff);
buff = fgets(fid);
buff = sscanf(buff,'%d%d%d',3);
Nb = buff(1); Nk = buff(2); Nw = buff(3);
fprintf(wid,'\t%d\t%d\t%d\n',[num_target_bands Nk Nw]);

if ~(num_target_bands < Nb)
    fclose(fid);
    fclose(wid);
    error('There must be less target bands than actual bands!')
end
if num_target_bands < Nw
    fclose(fid);
    fclose(wid);
    error('Less target bands than wannier functions!')
end


buff = fgets(fid);
% num_bytes_per_line = length(buff);
% while ischar(buff)
while ischar(buff)
    fwrite(wid,buff);
    for jj = 1:num_target_bands-1
        buff = fgets(fid);
        fwrite(wid,buff);
    end
%     fseek(fid,(Nb-num_target_bands)*num_bytes_per_line,'cof');
    for skip=1:Nb-num_target_bands
        fgets(fid);
    end
    buff = fgets(fid);
end
fclose(fid);
fclose(wid);

end
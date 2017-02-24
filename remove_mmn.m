function [ ] = remove_mmn( file_name, num_target_bands )
%CUT_MMN Summary of this function goes here
%   Detailed explanation goes here

fid = fopen(file_name);
wid = fopen([file_name(1:end-4) '_' num2str(num_target_bands) 'bands.mmn'],'w');
buff = fgets(fid);
fwrite(wid,buff);
buff = fgets(fid);
buff = sscanf(buff,'%d%d%d',3);
Nb = buff(1); Nk = buff(2); Nn = buff(3);
fprintf(wid,'\t%d\t%d\t%d\n',[num_target_bands Nk Nn]);

if ~(num_target_bands < Nb)
    fclose(fid);
    fclose(wid);
    error('There must be less target bands than actual bands!')
end

fgets(fid);
buff = fgets(fid);
num_bytes_per_line = length(buff);
frewind(fid);fgets(fid);fgets(fid);buff = fgets(fid);

while ischar(buff)
%     buff = fgets(fid);
    fwrite(wid,buff);
    for jj = 1:num_target_bands
        for ii=1:num_target_bands
            buff = fgets(fid);
            fwrite(wid,buff);
        end
        fseek(fid,(Nb-num_target_bands)*num_bytes_per_line,'cof');
    end
    fseek(fid,(Nb-num_target_bands)*Nb*num_bytes_per_line,'cof');
    buff = fgets(fid);
end
fclose(fid);
fclose(wid);

end
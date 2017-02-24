function [ ] = remove_eig( file_name, num_target_bands )
%CUT_EIG Summary of this function goes here
%   Detailed explanation goes here

fid = fopen(file_name);
wid = fopen([file_name(1:end-4) '_' num2str(num_target_bands) 'bands.eig'],'w');

for ii=1:num_target_bands
    buff = fgets(fid);
    fwrite(wid,buff);
end
Nb = sscanf(buff,'%d',1);
for ii=1:10000
    buff = fgets(fid);
    Nb_new = sscanf(buff,'%d',1);
    if Nb > Nb_new
        break
    end
    Nb = Nb_new;
end
if ii==10000
    error('More than 10000 bands encountered!')
end
num_bytes_per_line = length(buff);

while ischar(buff)
    fwrite(wid,buff);
    for ii=1:num_target_bands-1
        buff = fgets(fid);
        fwrite(wid,buff);
    end
    fseek(fid,(Nb-num_target_bands)*num_bytes_per_line,'cof');
    buff = fgets(fid);
end

fclose(fid);
fclose(wid);

end
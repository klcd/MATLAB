function [ ] = remove_bands( file_name, num_target_bands )
%CUT_EIG Summary of this function goes here
%   Detailed explanation goes here

disp(['Removing bands from ' file_name '.eig...']);
remove_eig([file_name '.eig'],num_target_bands);

disp(['Removing bands from ' file_name '.amn...']);
remove_amn([file_name '.amn'],num_target_bands);

disp(['Removing bands from ' file_name '.mmn...']);
remove_mmn([file_name '.mmn'],num_target_bands);

%% Finally change the number of bands in the .win file
disp(['Setting the correct number of bands in ' file_name '.win...']);
win = fileread([file_name '.win']);
[a,b] = regexp(win,'num_bands([^\n]*)');
temp_str = win(a:b); temp_str = strsplit(temp_str,' ');
win = regexprep(win,'num_bands([^\n]*)',[temp_str{1} ' = ' num2str(num_target_bands)]);
fid = fopen([file_name '.win'],'w');
fprintf(fid,win);
disp('Done! Closing files...');
fclose(fid);
end
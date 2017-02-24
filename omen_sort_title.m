function [ output_args ] = omen_sort_title(output_file, title )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

out = fopen(output_file,'at');
fprintf(out,'%s\n',' ');
fprintf(out,'%s\n','/*****************************************');
fprintf(out,'%s\n',title);
fprintf(out,'%s\n','*****************************************/');
fclose(out);

end


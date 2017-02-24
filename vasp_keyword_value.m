function [value ] = vasp_keyword_value(keyword,file )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
fid = fopen(file, 'r')


while 1;
    line = fgetl(fid);
    if  length(findstr(line,keyword)) > 0
        val = strsplit(line,{'=','//'});
        value = val(2);
        break;
    end
end

fclose(fid)
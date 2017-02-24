function [value] = vasp_keyword_change(filename,keyword,error)
%Searches the file 'filename' for a keyword and returns its value. The file
%must have the following format.
%  keyword1 = 129
%  keyword2 = 2309
%  keyword3 = 482
%  etc



fin = fopen(filename,'r');

value = NaN;



found = 0;
while ~found;
    s = fgetl(fin);
    p = strtrim(strsplit(s,{'=','//'}));
    k = char(p(1));
    if  strcmp(k,keyword);
        found = 1;
        value = str2double(char(p(2)));
        break;
    end
end

if value == NaN
    disp(['Couldn"t find keyword. Check the file ' filename 'for the keyword ' keyword])
    if error == 1;
        error('Programm stops')
    end
end


end
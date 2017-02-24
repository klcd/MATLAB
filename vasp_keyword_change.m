function [ output_args ] = vasp_keyword_change(filename,keyword,new_value)
%If keyword is found the line is replaced by "keyword = new_value"

fin = fopen(filename,'r');
fout = fopen('filename_new','w');


while ~feof(fin);
    s = fgetl(fin);
    p = strtrim(strsplit(s,{'=','//'}));
    p = char(p(1));
    if  strcmp(p,keyword);
        s = [keyword,' = ', new_value];
    end
    
    fprintf(fout,'%s\n',s);
end

fclose(fin);
fclose(fout);

system([['mv filename_new',' ', filename]]);


end


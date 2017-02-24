function [ output_args ] = vasp_line_change(filename,number,new_line)
%If the file "filename" contains enough lines, line "number" is replaced by
%"newline"


% filename   - string
% number     - int
% new_line   - string


fin = fopen(filename,'r');
fout = fopen('filename_new','w');

idk = 0;

while ~feof(fin);
    idk = idk + 1;
    s = fgetl(fin);
    
    if  idk == number;
        s = new_line;
    end
    
    fprintf(fout,'%s\n',s);
end

fclose(fin);
fclose(fout);

system([['mv filename_new',' ', filename]]);

end


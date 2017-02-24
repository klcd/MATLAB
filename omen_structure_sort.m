function [CM] = little_omen_sort(CM,params_list, output_file,comments)
% comments 0: no comments 1:comments

params = fopen(params_list);
out = fopen(output_file,'at');


%Determine the parameters that should be searched
PM = strtrim(textscan(params,'%s'));
PM = PM{1};

found = [];

for i = 1:length(PM)
    
    f = strfind(CM(:,1), PM{i});
    ind = find(~cellfun(@isempty,f));
    found = [found ind'];
    
    for i = 1:length(ind)
        if comments ==0;
            tab1 = 20 - lenght(CM{ind(i),1});
            s = [char(CM{ind(i),1}), blanks(tab1), ' = ', char(CM{ind(i),2})];
        elseif comments ==1;
            if length(CM{ind(i),3}) == 0
                tab1 = 20 - length(CM{ind(i),1});
                s = [char(CM{ind(i),1}), blanks(tab1), ' = ', char(CM{ind(i),2})];
            else
                tab1 = 20 - length(CM{ind(i),1});
                s = [char(CM{ind(i),1}), blanks(tab1), ' = ', char(CM{ind(i),2})];
                tab2 = 50 - length(s);
                s = [s,blanks(tab2),'//',char(CM{ind(i), 3})];
            end
        
        end
        fprintf(out,'%s\n',s);
    end
    

   
end

CM(found,:) = [];

fclose('all');


end

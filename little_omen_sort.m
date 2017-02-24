function [CM] = little_omen_sort(CM,params_list, output_file,comments)
% comments 0: no comments 1:comments

params = fopen(params_list);
out = fopen(output_file,'at');



%Determine the parameters that should be searched
PM = strtrim(textscan(params,'%s'));
PM = PM{1};

found = zeros(length(CM(:,1)),1);

for i = 1:length(PM)
    
    f = strcmp(CM(:,1), PM(i));
    g = strcmp(CM(:,1), ['//' PM{i}]);
    
    
    fsum = sum(f);
    gsum = sum(g);
    
    if fsum+gsum == 1;
        
        found = found + (f + g);
        
        if fsum ==1;
            [~,ind] = max(f);
        else 
            [~,ind] = max(g);
        end
        
        
        if comments ==0;
            tab1 = 20 - lenght(CM{ind,1});
            s = [char(CM{ind,1}), blanks(tab1), ' = ', char(CM{ind,2})];
        elseif comments ==1;
            if length(CM{ind,3}) == 0
                tab1 = 20 - length(CM{ind,1});
                s = [char(CM{ind,1}), blanks(tab1), ' = ', char(CM{ind,2})];
            else
                tab1 = 20 - length(CM{ind,1});
                s = [char(CM{ind,1}), blanks(tab1), ' = ', char(CM{ind,2})];
                tab2 = 50 - length(s);
                s = [s,blanks(tab2),'//',char(CM{ind, 3})];
            end
        
        end
            
        fprintf(out,'%s\n',s);
        
    elseif  fsum+gsum > 1
        [~,ind] = max(f)
        disp(['The Parameter ' char(CM{ind,1}) ' was found at least twice. Please delete the repetitions'])
        
    end
   
end

fclose('all');

%Delete all found data from CM
CM(find(found),:) = [];

end


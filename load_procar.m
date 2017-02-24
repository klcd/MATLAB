function load_procar()
    A = importdata('procar_matlab.dat','\t',5);
    t = A.textdata;
    a_names= split_str(' ',t{1});
    a_numbers_cell= split_str(' ',t{2});
    NAtypes = length(a_numbers_cell);
    a_numbers = zeros(1,NAtypes);
    for var_i=1:NAtypes
        a_numbers(var_i)=str2num(a_numbers_cell{var_i});
    end
    Nkpts = str2num(t{3});
    Nbands = str2num(t{4});
    NA = str2num(t{5});
    
    D = A.data;
    
    M = reshape(D',3,NA,Nbands,Nkpts);
    
    a_limit1=1;    
    
    sumM = zeros(3,NAtypes,Nbands,Nkpts);
    for var_i = 1:NAtypes
        a_limit2=a_limit1+a_numbers(var_i)-1;
        sumM(:,var_i,:,:)=sum(M(:,a_limit1:a_limit2,:,:),2);
        a_limit1=a_limit2+1;
    end
    
    [maxM1,ind1]=max(sumM,[],1);
    [maxM2,ind2]=max(maxM1,[],2);
    
    load energies.dat;
    E = reshape(energies,Nbands,Nkpts);
    figure
     plot([-1:-1],[1:3*NAtypes])
    hold on
    c=get(0,'DefaultAxesColorOrder');
    symb={'o','x','s'};
    for var_type=1:3*NAtypes
        bs = zeros(Nbands,Nkpts);
        for var_b=1:Nbands
            for var_k=1:Nkpts
                i2=ind2(1,1,var_b,var_k);
                i1=ind1(1,i2,var_b,var_k);
            
                Ni= 3*(i2-1)+i1;
                if (Ni==var_type)
                    bs(var_b,var_k)=E(var_b,var_k);
                else
                    bs(var_b,var_k)=NaN;
                end
            end
        end
        plot(1:Nkpts,bs',symb{mod(floor((var_type-1)/length(c(:,1))),length(symb))+1},'markeredgecolor',c(mod(var_type-1,length(c(:,1)))+1,:),'markerfacecolor',c(mod(var_type-1,length(c(:,1)))+1,:), 'markersize',4);
    end
    
    
    for var_i=1:NAtypes
        legendstring{(var_i-1)*3+1} = [a_names{var_i},' s'];
        legendstring{(var_i-1)*3+2} = [a_names{var_i},' p'];
        legendstring{(var_i-1)*3+3} = [a_names{var_i},' d'];
    end
    
   
    l=legend(legendstring);
    axis([min(1,Nkpts-1) max(Nkpts,2) min(min(E)) max(max(E))])
end

function parts = split_str(splitstr, str)
%split_str Split a string based upon an array of character delimiters
%
%   split_str(splitstr, str) splits the string STR at every occurrence
%   of an array of characters SPLITSTR and returns the result as a cell
%   array of strings.
%
%   usage: split_str(['_';','],'hi,there_how,you_doin?')
%
%   ans =
%
%    'hi'    'there'    'how'    'you'    'doin?'
%
   nargsin = nargin;
   error(nargchk(2, 2, nargsin));

   splitlen = 1;  %char's of length 1
   parts = {};

   k=[];           %empty array holding indexes of where to split
   last_split = 1; %index of last split

      for x=1:length(splitstr)
          k = [k strfind(str, splitstr(x))];     %combines all the found indexes
      end

      k = sort(k);   %sorts out indexes

      if isempty(k)
         parts{end+1} = str;
         return;
      end

      for x=1:length(k)
          parts{end+1} = str(last_split : k(x)-1);

          last_split = k(x)+1;
      end

      %now add the final string to the result
      parts{end+1} = str(last_split : length(str));
end

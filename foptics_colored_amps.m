%Data
load EIGEN.dat
load SCALED_WEIGHTS.dat
load AMPS_XX.dat
load AMPS_YY.dat
load overlaps.mat

AMPS = (AMPS_XX+AMPS_YY)/2;
weights = SCALED_WEIGHTS;
nb_val =vasp_check_keyword('RUNINFO','NBVAL',1);
nb_con_use = vasp_check_keyword('RUNINFO','NBCON_USE',1);

vals =18:18;
cons = 1:1;

single_plot = 0;

minO = 1.5;
maxO = 3.5;

minind = (min(vals)-1)*nb_con_use + min(cons);
maxind = (max(vals)-1)*nb_con_use + max(cons);
nkpt = size(AMPS,2);


trans = zeros(size(vals,2)*size(cons,2),nkpt);
amps = zeros(size(vals,2)*size(cons,2),nkpt);
names = cell(size(vals,2)*size(cons,2),nkpt);
counter = 0;
for val = vals
    for con = cons
        %Line in AMPS
        counter = counter+1;
        line_trans = (val-1)*nb_con_use+con;
        amps(counter,:) = AMPS(line_trans,:);
        
        %Transition energies
        trans(counter,:) = EIGEN(nb_val+con,:) - EIGEN(val,:);
        
        for i = 1:nkpt
        names{counter,i} = [overlaps{val,i} ' to ' overlaps{nb_val+con,i}];
        
        
        end
        
%         for i = 1:size(EIGEN,2)
%             %     bin1 = round((trans(1,i)-minO)/binsize)+1;
%             %     data1(1,bin1) = data1(1,bin1) + weights(1,i)*amps(1,i);
%             hold on
%             plot([trans(1,i), trans(1,i)],[0,weights(1,i)*amps(1,i)],'r-')
%             
%         end
        
        
    end
end
clear counter;

figure
all_names = unique(names);
c = get(0,'DefaultAxesColorOrder');

if size(all_names,1) >7
    c = jet(size(all_names,1));
end


h = zeros(size(amps,1),nkpt);
for i = 1:size(amps,1)
    for j = 1:nkpt
        hold on
        h(i,j) = plot([trans(i,j), trans(i,j)],[0,weights(1,j)*amps(i,j)]);
        
        [~,col] = max(strcmp(all_names,names{i,j}));
        set(h(i,j), 'Color', c(col,:))
    end
end
box on

g = zeros(size(all_names,2),1);
for i = 1:size(all_names,2)
    g(i) = plot(NaN,NaN);
    set(g(i),'Color',c(i,:))
end



[l,icons,plots,legend_text]=legend(g,all_names);



% title(['MoS_2: vb ' num2str(nb_val-val+1) ' to cb ' num2str(con)],'FontSize',30)
% box on
% ylabel('Oscillatorstrength','Fontsize',20)
% xlabel('Photon energy [eV]','Fontsize',20)
% xlim([minO,maxO])
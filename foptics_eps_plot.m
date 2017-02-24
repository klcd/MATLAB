load ep_xx.mat;
load ep_yy.mat;

eps = (ep_xx + ep_yy)./2;

frachem1 = 2*pi/(4.135667662*2.99792458)*10^-3;

val = 17:18;
con = 1:8;
summed = 1;
full_sum = 1;
scale = 1;
rangestart = 0;
rangeend = 3.5;

scale_const = vasp_check_keyword('RUNINFO','CONST',1)
nb_val = vasp_check_keyword('RUNINFO','NBVAL',1)
nb_con_use = vasp_check_keyword('RUNINFO','NBCON_USE',1);
minO = vasp_check_keyword('OPTCTR','OMIN',1);
maxO = vasp_check_keyword('OPTCTR','OMAX',1);
nedos = size(eps,2);




ens = linspace(minO,maxO,nedos);
sume = zeros(1,size(eps,2));

[B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar(); 
Lz = B(3,3)*a;
%eps = frachem1*eps*Lz;
eps =eps*Lz;


legendstring = cell(1,size(val,2)*size(con,2)+2*summed);
legendstring{1,end-1} = 'Sum';
legendstring{1,end} = 'All Transitions';

c = hsv(size(val,2)*size(con,2)+summed);
plots = zeros(1,size(val,2)*size(con,2) + 2*summed);
figure
k = 1;
for i = fliplr(val)
    for j = con
    
    hold on
    plots(1,((i-min(val)+1)-1)*size(con,2) + (j-min(con)+1)) = ...      
        plot(ens,eps((i-1)*nb_con_use+j,:));        
        %plot(ens,1-exp(-ens.*eps((i-1)*nb_con_use+j,:)));

    
    set(plots(1,((i-min(val)+1)-1)*size(con,2) + (j-min(con)+1)), ... 
        'Color',c(((i-min(val)+1)-1)*size(con,2) + (j-min(con)+1),:));
    
    legendstring{k} = ...
        ['vb ' num2str(nb_val-i+1) ' to cb' num2str(j)];
    if summed == 1;
        sume = sume(1,:) + eps((i-1)*nb_con_use+j,:);
    end
    k = k+1;
    end
end
clear k;
hold off

if summed == 1;
    hold on 
    %plot(ens,1-exp(-ens.*sume))
    plot(ens,sume)
    hold off
end

if full_sum== 1;
    hold on 
    %plot(ens,1-exp(-ens.*sum(eps,1)))
    plot(ens,sum(eps,1))
    hold off
    box on
end
[ho,mo] = legend(legendstring,'Location','northwest');
for i = size(mo,1)/3+1:2:size(mo,1)
    mo(i).LineWidth = 5;
end
xlim([rangestart,rangeend])
%set(gca,'Ytick',[])
% xlabel('Photon energy [eV]','Fontsize',20)
% ylabel('A(E)','Fontsize',20)
% title('MoS_2 in IP','Fontsize',30)
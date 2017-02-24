%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Chose Parameters                                                         % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_read = 1;
%Chosen
val = 9;
con = 1;
minEn = 0;
maxEn = 3.5;
bins = 600; %Default


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Loading the data                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if data_read == 0
    %Dielectric Data
    load ep_xx.mat;
    load ep_yy.mat;
    load ep_zz.mat;         
    load ep_xy.mat;
    load ep_xz.mat;
    load ep_yz.mat;

    eps = (ep_xx + ep_yy)./2;

    clear ep_xx ep_yy ep_zz ep_xy ep_xz ep_yz;
    %Amplitudes
    load EIGEN.dat
    load SCALED_WEIGHTS.dat
    load AMPS_XX.dat
    load AMPS_YY.dat
    load AMPS_ZZ.dat
    load AMPS_XY.dat
    load AMPS_XZ.dat
    load AMPS_YZ.dat

    amps = (AMPS_XX+AMPS_YY)/2;
    weights = SCALED_WEIGHTS;
    clear AMPS_XX AMPS_YY AMPS_ZZ AMPS_XY AMPS_XZ AMPS_YZ SCALED_WEIGHTS;

    %Joint density of states
   
    load SJDO
    jdos = zeros(size(SJDO));
    tic
    for i = fliplr(2:size(SJDO,1))
        jdos(i,:) = SJDO(i,:) - SJDO(i-1,:);
    end
    jdos(1,:) = SJDO(1,:);
    toc
    
    
    clear SJDO
else
    disp('Note that the data is not reread')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Parameters read from files                                               % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nb_val = vasp_check_keyword('RUNINFO','NBVAL',1);
const = vasp_check_keyword('RUNINFO','CONST',1)
nb_con_use = size(jdos,1)/nb_val;
minO = vasp_check_keyword('OPTCTR','OMIN',1);
maxO = vasp_check_keyword('OPTCTR','OMAX',1);
nedos = size(jdos,2)-1;


if val > nb_val
    error('The valence band does not exist')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Needed Data                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Dielectric
plot_eps = eps((val-1)*nb_con_use+con,:);

%Amplitudes
plot_amps = amps((val-1)*nb_con_use+con,:).*weights;
trans = EIGEN(nb_val+con,:) - EIGEN(val,:);


% binsize = (maxO-minO)/bins;
% pamps = zeros(1,bins+1);
% for i = 1:size(EIGEN,2)
%     bin = round((trans(1,i)-minO)/binsize)+1;
%     if bin < bins
%         pamps(1,bin) = pamps(1,bin) + weights(1,i)*plot_amps(1,i);
%     end
% end


%Jdos

deltaE = (maxO - minO)/(nedos);
ens = minO:deltaE:maxO;
plot_jdos = jdos((val-1)*nb_con_use+con,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Scaling                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[B,Ap,a,N,T,id,crvimystal,sel_dyn, dyn_tag] = vasp_read_poscar(); 
Lz = B(3,3)*a;
plot_eps = plot_eps*Lz;



scal_jdos = max(plot_eps)/max(plot_jdos)/2;
scal_amp = max(plot_eps)/max(plot_amps)/4;
%scal_amp = max(plot_eps)/max(pamps)/4;
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plots                                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure

hold on
plot(ens,plot_eps,'b')
hold on
plot(ens,scal_jdos*plot_jdos,'r-.')
for i = 1:size(EIGEN,2)
    hold on
    plot([trans(1,i), trans(1,i)],[0,scal_amp*plot_amps(1,i)],'k-')
end

%bar(minO:binsize:maxO,scal_amp*pamps,'k')
xlim([minEn, maxEn])
box on
hold off
%set(gca,'Ytick',[])
xlabel('\fontsize{15} Photon energy [eV]')
title(['\fontsize{20} Absorption from vb ' num2str(nb_val+1-val) ' to cb ' num2str(con)])
legend('Dielectric function','Joint density of states','Oscillator strengts','Location','northwest')


%bar(minO:binsize:maxO,10+log10(scal_amp*pamps))
%plot(ens,10+log10(plot_eps))
%plot(ens,10+log10(scal_jdos*plot_jdos),'-.')
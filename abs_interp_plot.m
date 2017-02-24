%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Chose Parameters                                                         % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_read = 1;
%Chosen
val = 9;
con = 1;
minEn = 0;
maxEn = 3;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Loading the data                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if data_read ==1
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
    if ~exist('jdos.mat','file')
        load SJDO
        jdos = zeros(size(SJDO));
        tic
        for i = fliplr(2:size(SJDO,1))
            jdos(i,:) = SJDO(i,:) - SJDO(i-1,:);
        end
        jdos(1,:) = SJDO(1,:);
        toc
        save('jdos.mat','jdos')
    else
        load jdos.mat;
    end

    clear SJDO
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Parameters                                                               % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Should be read from somewhere
nb_val = 9;
nb_con_use = size(jdos,1)/nb_val;
minO = vasp_check_keyword('OPTCTR','OMIN');
if minO == NaN;
   minO = 0;
end
maxO = vasp_check_keyword('OPTCTR','OMAX');
if maxO == NaN;
   maxO = 20;
end
nedos = size(jdos,2)-1;
bins = 600;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Needed Data                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Dielectric
plot_eps = eps((val-1)*nb_con_use+con,:);

%Amplitudes
plot_amps = amps((val-1)*nb_con_use+con,:);
trans = EIGEN(nb_val+con,:) - EIGEN(val,:);

binsize = (maxO-minO)/bins;
pamps = zeros(1,bins+1);
for i = 1:size(EIGEN,2)
    bin = round((trans(1,i)-minO)/binsize)+1;
    pamps(1,bin) = pamps(1,bin) + weights(1,i)*amps(1,i);
end


%Jdos

deltaE = (maxO - minO)/(nedos);
ens = minO:deltaE:maxO;
plot_jdos = jdos((val-1)*nb_con_use+con,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Scaling                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

scal_jdos = max(plot_eps)/max(plot_jdos)/2;
scal_amp = max(plot_eps)/max(pamps)/4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plots                                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%figure
plot(ens,plot_eps)
hold on
bar(minO:binsize:maxO,scal_amp*pamps)
plot(ens,scal_jdos*plot_jdos,'-.')
xlim([minEn, maxEn])
set(gca,'Ytick',[])
xlabel('\fontsize{15} Photon energy [eV]')
title(['\fontsize{20} Absorption from vb ' num2str(nb_val+1-val) ' to cb ' num2str(con)])

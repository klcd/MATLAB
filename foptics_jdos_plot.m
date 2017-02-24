if ~exist('./jdos.mat','file')
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



%Should be read from somewhere
nb_val = vasp_check_keyword('RUNINFO','NBVAL');
nb_con_use = size(jdos,1)/nb_val;
minO = vasp_check_keyword('OPTCTR','OMIN');
maxO = vasp_check_keyword('OPTCTR','OMAX');
nedos = size(jdos,2)-1;

%Chosen
val = 9:nb_val;
con = 1:1;
summing = 0;
minEn = 0;
maxEn = 10;


deltaE = (maxO - minO)/(nedos);
ens = minO:deltaE:maxO;


summed = zeros(1,nedos+1);

for i = fliplr(val)
    for j = con
    hold on
    plot_jdos = jdos((i-1)*nb_con_use+j,:);
    plot(ens, plot_jdos,'-.')
    summed = summed + jdos((i-1)*nb_con_use+j,:);
    end
end

if summing == 1;
    plot(ens,summed)
    plot(ens,sum(jdos,1))
end
xlim([minEn,maxEn])
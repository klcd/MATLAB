%Data
load EIGEN.dat
load SCALED_WEIGHTS.dat
load AMPS_XX.dat
load AMPS_YY.dat

AMPS = (AMPS_XX+AMPS_YY)/2;
weights = SCALED_WEIGHTS;
nb_val =vasp_check_keyword('RUNINFO','NBVAL',1);
nb_con_use = vasp_check_keyword('RUNINFO','NBCON_USE',1);

vals =400:549;
cons = 1:90;

single_plot = 0;

minO = 1.4;
maxO = 3.2;

%figure
hold on
for val = vals
    for con = cons
        %Line in AMPS
        line_trans = (val-1)*nb_con_use+con;
        amps = AMPS(line_trans,:);
        
        %Transition energies
        trans = EIGEN(nb_val+con,:) - EIGEN(val,:);
        
        for i = 1:size(EIGEN,2)
            %     bin1 = round((trans(1,i)-minO)/binsize)+1;
            %     data1(1,bin1) = data1(1,bin1) + weights(1,i)*amps(1,i);
            hold on
            if(weights(1,i)*amps(1,i) > 10^(-3))
                plot([trans(1,i), trans(1,i)],[0,weights(1,i)*amps(1,i)],'r-')
            end
        end
        
        
    end
end
        

% if size(vals,2) == 1;
%     title(['MoS_2: vb ' num2str(nb_val-vals+1) ' to cb ' num2str(cons)],'FontSize',30)
%     box on
%     ylabel('Oscillatorstrength','Fontsize',20)
%     xlabel('Photon energy [eV]','Fontsize',20)
%     xlim([minO,maxO])
% end



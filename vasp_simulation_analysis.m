function [] = vasp_simulation_analysis(e_loop, i_loop)

%Entering Data into a cell
[~,a] = system('grep LOOP OUTCAR')
C = textscan(a, '%s %*s %*s %f: %*s %*s%f')


%Find the indexes of the relaxation loop times
idx_r = find(strcmp([C{:,1}], 'LOOP+:'))

%Times of electronic loop

idx_c = [1; idx_r-1]

if e_loop ==1;
    %steptimes of the electronic loops
    figure
    for i = 1:length(idx_r)
        hold on
        if idx_c(i) == 1
            plot(1:idx_c(2),C{1,2}(1:idx_c(2),1)')
        else
            x = 1:(idx_c(i+1)-idx_c(i)-1);
            y = C{1,3}(idx_c(i)+2:idx_c(i+1));
            plot(x,y)
            
        end
        
    end
end

if i_loop == 1;
    %nr steps in an electronic loop
    nr_steps = zeros(1,length(idx_r));
    
    for i = 1:length(idx_r)-1
        if i ==1
            nr_steps(i) = idx_r(i) -1;
        else
            nr_steps(i) = idx_r(i+1) - idx_r(i) -1;
        end
    end
    
    
    figure
    plot(1:length(idx_r),nr_steps)
    xlabel('Number of the electronic loop')
    ylabel('Number of electronic steps made')
    
    %time per ionic loop
    figure
    plot(1:length(idx_r),C{1,3}(idx_r))
    xlabel('n-th ionic loop')
    ylabel('time [s]')
end

end

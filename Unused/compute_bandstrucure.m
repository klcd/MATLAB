function [ k, Ek ] = compute_bandstrucure( Hblocks, k, wf_list_m, wf_list_r, wf_list_l, type, len )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

num_wf = length(wf_list_m);

if isempty(k)
    if strcmp(type,'line')
        k = [linspace(0,pi,len); zeros(1,len); zeros(1,len)];
    elseif strcmp(type,'grid')
        k = [repmat(linspace(-pi,pi,len),1,len*len); repmat(sort(repmat(linspace(-pi,pi,len),1,len)),1,len); sort(repmat(linspace(-pi,pi,len),1,len*len))];
    end
end
Ek = zeros(num_wf,length(k));

disp(['Computing the bands at ' num2str(length(k)) ' k-points...'])
for kk=1:length(k)
    if ~mod(kk,10)
        disp(['k-point no: ' num2str(kk)])
    end
    Hk = zeros(num_wf);
    for xx = -1:1
        
        if xx == -1
            wfs = wf_list_l;
        elseif xx == 0
            wfs = wf_list_m;
        elseif xx == 1
            wfs = wf_list_r;
        end
        
        for yy = -1:1
            
            for zz = -1:1
%                 r = vec(1,:)*xx + vec(2,:)*yy + vec(3,:)*zz; % row vector
                r = [xx yy zz]; % row vector
                Hk = Hk + exp(1i*r*k(:,kk))*Hblocks{yy+2,zz+2}(wf_list_m,wfs);
            end
            
        end
        
    end
    [~, E] = eig(real(Hk));
    [E, ~] = sort(real(diag(E)));
    Ek(:,kk) = E; 
end
end


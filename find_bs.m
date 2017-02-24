function [E,k] = find_bs(B,kI)
% function to find bandstructure information for easy plotting
% CALL: [E,k] = find_bs(B,kI)
%
% terminology:
% - Nk: # of kpoints according to kI
% - Nb: # of bands according to B
%
% input args:
% - B: band data as provided by 'read_procar'
% - kI: indices of kpoints to include
%
% output args:
% - E: vector of energies, size 1xNk*Nb
% - k: vector of [0,1] corresponding tro data in E, size 1xNk*Nb


%% get E,k
Nk = length(kI);
Nb = length(B(1).E);

khat = linspace(0,1,Nk);
k=[]; E=[];
for c=1:Nk
    k = [k ones(1,Nb)*khat(c)];
    E = [E B(kI(c)).E];
end

end
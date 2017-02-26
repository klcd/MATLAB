function [ H ] = create_Hamiltonian_with_periodic_shift(shift_p,shift_y,Hblocks_full,Nwf_per_region,wf_list,N_cell,structure_param)

s = size(Hblocks_full);

% number of blocks in the Hblocks cell along the transport- and the periodic
% axis:

Nt = s(1);
Np = s(2);
if( length(s) > 2)
    Ny = s(3);
else
    Ny = 1;
end

% number of nearest-neighbors in the transport direction (3 blocks means
% first-neighbors only, 5 blocks means second-neighbors too...)

NN_t = round((Nt-1)/2);

% last 2 indices of the blocks (depends on whether it is H0, H1, H2, ...
% that is being created now)

Ip = round((Np+1)/2 +shift_p);
Iy = round((Ny+1)/2 +shift_y);

% total number of Wannier functions in the device

len_i= N_cell.*Nwf_per_region(1:structure_param.Nregions);
len = sum(len_i);

% initialize the Hamiltonian matrix

H = sparse(len,len);

% Number of different regions

Nregions=structure_param.Nregions;



% assume we have two regions, and only first-neighbor block interactions. The 
% A, B, and C matrices will contain the interactions at the left side, D,
% E, and F the interactions on the right side of the device, and there will
% be the X and Y matrices where the two regions merge.
%
% H=
%
% BC
% ABC
%  ABC
%   ABX
%    YEF
%     DEF
%      DEF
%       DEF
%
% In fact all these blocks are subblocks of Hblocks{:,Ip,Iy}, because Hblocks
% was created assuming that we have all the atoms in the unit cell, and 
% A,B,C and D,E,F are square matrices, but they migh have different sizes.
% Therefore X and Y are not necessary square matrices.
%
% First those parts with the A,B,C and D,E,F matrices are created, without
% X and Y:

for region=1:Nregions
    
    % where the indexing should start from
    
    if (region==1)
        regionshift=0;
    else
        regionshift=sum(len_i(1:region-1));
    end
    
    % Just tile the matrix with the appropriate blocks of Hblocks
    
    for Icell1 = 1:N_cell(region)
        mincell = max([1 Icell1-NN_t]);
        maxcell = min([N_cell(region) Icell1+NN_t]);
        for Icell2 = mincell:maxcell
            H((regionshift+Nwf_per_region(region)*(Icell1-1)+1):(regionshift+Nwf_per_region(region)*Icell1),(regionshift+Nwf_per_region(region)*(Icell2-1)+1):(regionshift+Nwf_per_region(region)*Icell2)) = Hblocks_full{round((Nt+1)/2 + Icell2 - Icell1),Ip,Iy}(wf_list{region},wf_list{region});
        end
    end
end


% Now create the parts where the different regions are connected (if there
% is more than one region)

wf_list_full = wf_list{Nregions+1};
for region=2:(Nregions)

    regionshift=sum(len_i(1:region-1));
    
    % the indices of those Wannier functions that are present in the right
    % side of the interface:
    
    ind1 = ismember(wf_list_full,wf_list{region});
    
    % the indices of those Wannier functions that are present in the left
    % side of the interface:
    
    ind2 = ismember(wf_list_full,wf_list{region-1});

    % create the block marked with Y above (or matrices if there are more
    % than first-neighbor block interactions)
    
    for Icell1 = 1:NN_t
        for Icell2 = (Icell1-NN_t:0)
            Hb =  Hblocks_full{round((Nt+1)/2 + Icell2 - Icell1),Ip,Iy};
            Hb = Hb(ind1,ind2);
            H(regionshift + Nwf_per_region(region)*(Icell1-1)+(1:length(wf_list{region})),regionshift+Nwf_per_region(region-1)*(Icell2-1)+(1:length(wf_list{region-1}))) = Hb;
        end
    end
    
    % create the block marked with X
    
    for Icell2 = 1:NN_t
        for Icell1 = (Icell2-NN_t:0)
            Hb =  Hblocks_full{round((Nt+1)/2 + Icell2 - Icell1),Ip,Iy};
            Hb = Hb(ind2,ind1);
            H(regionshift + Nwf_per_region(region-1)*(Icell1-1)+(1:length(wf_list{region-1})),regionshift+Nwf_per_region(region)*(Icell2-1)+(1:length(wf_list{region}))) = Hb;
        end
    end

end


end
function [ coords ] = repeat_crystal( coords,vectors,n1,n2,n3 )
%REPEAT_CRYSTAL Summary of this function goes here
%   Detailed explanation goes here

[l,~]=size(coords);
vectors = vectors.';

for ii=1:l
    
    [m,n] = size(coords{ii,3});
    coords_new = zeros(n,m*(n1+1)*(n2+1)*(n3+1));
    coords_tmp = coords{ii,3}.';
    coords_new(:,1:m) = coords_tmp;
    %% first expand in the x-y plane
    ind = -1;
    for jj=0:n1
        
        for ll=0:n2
            ind = ind + 1;
            for kk=1:m
                coords_new(:,ind*m+kk) = coords_new(:,kk)+jj*vectors(:,1)+ll*vectors(:,2);
            end
        end
    end
    %% The z direction is not coupled to the others!
    ind = m*n1*n2;
    for jj=1:n3
        for kk=1:m*n1*n2
            coords_new(:,jj*ind+kk) = coords_new(:,kk)+jj*vectors(:,3);
        end
    end
    coords{ii,3} = unique(coords_new.','rows');
    coords{ii,2} = length(coords{ii,3}(:,1));
    
end

end


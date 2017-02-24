function [ ] = downsize_Hamiltonian_symmetric( remove_list, path )
%DOWNSIZE_HAMILTONIAN Summary of this function goes here
%   Detailed explanation goes here
%
% do everything 9 times, for each amiltonian

if length(remove_list) ~= (remove_list(end)-remove_list(1)+1)
    warning('Not good')
end

% indices
ii = remove_list(1);
jj = remove_list(end);
num_remove = length(remove_list);

for hh = 0:8
    if exist('path','var')
        H = load_binary_Hamiltonian([path 'H_' num2str(hh) '.bin']);
    else
        H = load_binary_Hamiltonian(['H_' num2str(hh) '.bin']);
    end
    
%     H1 = H(1:ii-1,1:ii-1);
%     H2 = H(jj+1:end,num_remove+1:num_remove+ii-1);
%     H3 = H(num_remove+1:end,jj+1:end);
%     
%     len_old = length(H);
%     len_new = len_old - num_remove;
%     
%     H_small = sparse(len_new,len_new);
%     H_small(1:ii-1,1:ii-1) = H1;
%     H_small(ii:end,1:ii-1) = H2;
%     H_small(:,ii:end) = H3;
    H_small = H(jj+1:end-jj,jj+1:end-jj);
    
%     if exist('path','var')
%         save_Hamiltonians_binary(H_small,[path 'H_' num2str(hh) '_reduced.bin']);
%     else
        save_Hamiltonians_binary(H_small,['H_' num2str(hh) '_reduced.bin']);
    disp(['New size: ' num2str(length(H_small))])
%     end
end
end


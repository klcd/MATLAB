function [ ] = downsize_Hamiltonian_general( rs, load_path, save_path )
%DOWNSIZE_HAMILTONIAN Summary of this function goes here
%   Detailed explanation goes here
%
% 


%% each block can only contain a list of consecutive wf
for ss = 1:length(rs)
    remove_list = rs{ss}.list;
    if length(remove_list) ~= (remove_list(end)-remove_list(1)+1)
        error('Not good')
    end
    rs{ss}.removed = false;
end

%% There can be only one beginning and ending block
% get the size of the old hamiltonian
if exist('load_path','var')
    fid = fopen([load_path 'H_0.bin'],'rb');
else
    fid = fopen('H_0.bin','rb');
end
% fid = fopen(filename,'rb');
len = fread(fid,1,'double');
fclose(fid);
% check the blocks
b_count = 0;
e_count = 0;
for ss = 1:length(rs)
    if strcmp(rs{ss}.pos,'beg')
        if rs{ss}.list(1) ~= 1
            warning('Beginning block is not at the beginning.')
            rs{ss}.pos = 'mid';
        else
            b_count = b_count+1;
        end
    elseif strcmp(rs{ss}.pos,'end')
        if rs{ss}.list(end) ~= len
            warning('Ending block is not at the end.')
            rs{ss}.pos = 'mid';
        else
            e_count = e_count+1;
        end
    end
end
if b_count > 1 || e_count > 1
    error('Blocks are overlapping.')
end

%% if blocks follow each other immediately, merge them
for ss = 1:length(rs)
    for ss2 = ss+1:length(rs)
        if rs{ss}.removed
            continue
        end
        
        if remove_list(1) == rs{ss2}.list(end)+1
            % append the current block to the previous one
            rs{ss2}.list = [rs{ss2}.list remove_list];
            if strcmp(rs{ss}.pos,'beg')
                error(' ');
            elseif strcmp(rs{ss}.pos,'end')
                rs{ss2}.pos = 'end';
            else
                % nothing
            end
            rs{ss}.removed = true;
        elseif remove_list(end)+1 == rs{ss2}.list(1)
            % append the block to the current one
            rs{ss}.list = [remove_list rs{ss2}.list];
            if strcmp(rs{ss2}.pos,'beg')
                error(' ');
            elseif strcmp(rs{ss2}.pos,'end')
                rs{ss}.pos = 'end';
            else
                % nothing
            end
            rs{ss2}.removed = true;
        end
    end
end

%% Sort and delete merged blocks
% delete
r = zeros(1,length(rs));
for ss = 1:length(rs)
    if rs{ss}.removed
        r(ss) = ss;
        rs = rs{setdiff(1:length(rs),ss)};
    end
end
r = r(r~=0);
rs = rs(setdiff(1:length(rs),r));
% sort
ends = zeros(1,length(rs));
for ss = 1:length(rs)
    ends(ss) = rs{ss}.list(end);
end
[~,ind] = sort(ends,'descend');
rs = rs(ind);

%% load the matrix, remove the blocks and save the matrix back
for hh = 0:8
    if exist('load_path','var')
        H = load_binary_Hamiltonian([load_path 'H_' num2str(hh) '.bin']);
    else
        H = load_binary_Hamiltonian(['H_' num2str(hh) '.bin']);
    end
    
    for ss = 1:length(rs)
        
        ii = rs{ss}.list(1);
        jj = rs{ss}.list(end);
        num_remove = length(rs{ss}.list);
        
        if strcmp(rs{ss}.pos,'beg')
            
            H = H(jj+1:end,jj+1:end);
            
        elseif strcmp(rs{ss}.pos,'end')
            
            H = H(1:ii-1,1:ii-1);
            
        else
            
            H1 = H(1:ii-1,1:ii-1);
            H2 = H(jj+1:end,num_remove+1:num_remove+ii-1);
            H3 = H(num_remove+1:end,jj+1:end);

            len_old = length(H);
            len_new = len_old - num_remove;

            H = sparse(len_new,len_new);
            H(1:ii-1,1:ii-1) = H1;
            H(ii:end,1:ii-1) = H2;
            H(:,ii:end) = H3;
    
        end
    end
    
    disp(['nnz new: ' num2str(nnz(H))])
    disp(['s new: ' num2str(length(H))])
    if exist('save_path','var')
        save_Hamiltonians_binary(H,[save_path 'H_' num2str(hh) '.bin']);
    else
        save_Hamiltonians_binary(H,['H_' num2str(hh) '.bin']);
    end
end

end


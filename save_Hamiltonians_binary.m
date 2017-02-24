function [ ] = save_Hamiltonians_binary(H_sparse,filename)
% Save the matrices in a sparse format in binary files.

[row, col, val] = find(H_sparse);
[~,ind] = sort(row);

% order the indices by row and column.

ord_row = row(ind);
ord_col = col(ind);

% the imaginary parts are set to zero. It is probably unnecessary, since it
% was already set to 0 when reading in the Wannier90 output.

ord_real = real(val(ind));
ord_imag = zeros(nnz(H_sparse),1);

% sparse format: (row index, colun index, real part, imaginary part)

H = horzcat(ord_row,ord_col,ord_real,ord_imag);

% linear size

H_size = size(H_sparse);

% Header: linear size, number of nonzero elements, and 1 marks that the
% indexing starts from 1 (Matlab style).

H_header = [int2str(H_size(1)),' ',int2str(nnz(H_sparse)), ' 1'];

fid = fopen(filename,'wb');
fwrite(fid,str2num(H_header),'double');
fwrite(fid,H','double');
fclose(fid);

end


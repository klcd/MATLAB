function [ eq, rat_eq, num_eq ] = isequaltol( A,B,tol )
%ISEQUALTOL Compares each entry of A and B, uses a certain tolerance tol
%   Compares each entry of A and B on equality, but uses a tolerance tol
%   to decide on equality. Returns also the number of equal entries.
%   INPUT: A, B: Matrices, must be of the same size. A and B can be cells
%          with just one matrix at {1}.
%          tol: tolerance for the equality
%
%   OUTPUT: eq: true if each entry of A and B are equal up to tol, false
%               otherwise.
%           rat_eq: the ratio of equal to total entries
%           num_eq: the number of equal entries.

%% If A or B are cells contianing a single matrix, extract it.
if iscell(A) && length(A)==1
    A = A{1};
end
if iscell(B) && length(B)==1
    B = B{1};
end
%% Check wether A and B really are matrices
if ~(isnumeric(A) && isnumeric(B))
    error('A and B must be numeric matrices!')
end

%% Check the sizes of A and B
[ma,na] = size(A); [mb,nb] = size(B);
if ~(ma==mb && na==nb)
    error('A and B must be of equal size.')
end

test = abs(A-B)<tol;
num_eq = sum(sum(test));

if num_eq == ma*na
    eq = true;
else
    eq = false;
end
rat_eq = num_eq/(ma*na);
end


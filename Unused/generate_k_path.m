function [ k,dk ] = generate_k_path( corners, nk )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% m is the dimension, should be 3
% nc is the number of corners
[m,nc] = size(corners);
if m ~= 3
    error('Enter correct coordinates!');
end

% there are nk points per path
% nc-1 paths
k = zeros(3,nk*(nc-1));
for pp = 1:nc-1
    tmp = [linspace(corners(1,pp),corners(1,pp+1),nk); ...
        linspace(corners(2,pp),corners(2,pp+1),nk); ...
        linspace(corners(3,pp),corners(3,pp+1),nk)];
    k(:,nk*(pp-1)+1:nk*pp) = tmp;
end
% remove the duplicate k-points at the corners
k(:,1+nk:nk:end) = nan;
k = reshape(k(~isnan(k)),3,[]);

dk = [0 sqrt(sum((diff(k,1,2)).^2,1))];
end


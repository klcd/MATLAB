function k = kpath(P,N)
% function to generate a path in k-space
% CALL: k = kpath(P,N)
%
% input args:
% - P: points in k-space to generate the path in between, size dxn
% - N: number of k points in between the points in P, size 1x(n-1)
%
% output args:
% - k: path in k space, size 3xsum(N)


%% bitching
if (length(N)~=size(P,2)-1)
    error('need length(N)==size(P,2)-1')
end


%% function body
k = zeros(size(P,1),sum(N));
acc = 1;
for c=1:length(N)
    for d=1:size(P,1)
        k(d,acc:acc+N(c)-1) = linspace(P(d,c),P(d,c+1),N(c));
    end
    acc = acc+N(c);
end

end
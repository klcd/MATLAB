% Read some parameters
num_of_layers = 3;
p = POSCARcart;

% Discard the single atom in the first layer. The generator will put it un
% the origin.
if p(1,1)==0 && p(1,2)==0 && p(1,3)==0
    p = p(2:end,:);
end
coords = NaN(size(p));
l = length(p);
n = 0;

% Keep all the atoms within a certain area.
for ii = 1:l
    if p(ii,1)>-3 && p(ii,1)<1 && p(ii,2)>-3 && p(ii,2)<2
        n = n+1;
        coords(n,:) = p(ii,:);
    end
end

coords = coords(1:n,:);
% Insert the first layer at x=0
temp = sort(unique(coords(:,3)),'ascend');
temp = coords(coords(:,3)==temp(3),1:2);
coords = [temp zeros(3,1); coords];
n = length(coords);

% Only keep the specified number of layers. That is three*num_of_layers
% atoms.
while n > 3*num_of_layers
    inds = find(coords(:,3)~=max(coords(:,3)));
    coords = coords(inds,:);
    n = length(coords);
end
% Find the translation vectors.
% the lower corner of the topmost triangle is the fourth point in -y
% direction.
temp = sort(unique(coords(:,2)),'descend');
a1 = [max(coords(:,1))-min(coords(:,1))*1.5 -(temp(1)-temp(4)) 0];
a2 = [max(coords(:,1))-min(coords(:,1))*1.5  (temp(1)-temp(4)) 0];
temp = sort(unique(coords(:,3)),'descend');
% The z-vector is 
a3 = [0 0 2*temp(1)-temp(2)];

a = [a1;a2;a3]
disp(['# of atoms: ' num2str(length(coords))])
coords
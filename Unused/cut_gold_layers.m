%% Read some parameters
pos = c;
num_of_layers = 4;
xmin = -1.5; xmax = 1.5;
ymin = -8; ymax = -3;
x_pos = 0;
y_pos = 0;
z_pos = 0;

%% Output arrays
coords = NaN(size(pos));
vectors = NaN(3,3);

%% Internal variables
l = length(pos); n = 0;

%% Keep all the atoms within a certain area.
for ii = 1:l
    if pos(ii,1)>xmin && pos(ii,1)<xmax && pos(ii,2)>ymin && pos(ii,2)<ymax
        n = n+1;
        coords(n,:) = pos(ii,:);
    end
end
% Resize coords to cut the remaining NaN
coords = sortrows(coords(1:n,:),3);

%% Compute the z-distance between two layers
sorted_z_col = sort(unique(coords(:,3)),'descend');
delta_z = sorted_z_col(1)-sorted_z_col(2);

%% If the first layer has only one atom, fill in the rest
sorted_3rd_col = sort(coords(:,3),'descend');
% Count the number of atoms in the first layer
if sum(sorted_3rd_col==min(sorted_3rd_col)) < 3
    % Insert the atoms into the first layer.
    % The x-y coordinates in the first and fourth layer are equal
    x_y_coords = coords(coords(:,3)==sorted_z_col(end-3),1:2);
    coords = [x_y_coords ones(3,1)*min(sorted_3rd_col); coords(2:end,:)];
    n = length(coords);
end

%% Only keep the specified number of layers. That is three*num_of_layers
% atoms.
while n > 3*num_of_layers
    inds = find(coords(:,3)~=max(coords(:,3)));
    coords = coords(inds,:);
    n = length(coords);
end

%% Find the translation vectors.
% the lower corner of the topmost triangle is the fourth point in -y
% direction.
% temp = sort(unique(coords(:,2)),'descend');
% a1 = [max(coords(:,1))-min(coords(:,1))*1.5 -(temp(1)-temp(4)) 0];
% a2 = [max(coords(:,1))-min(coords(:,1))*1.5  (temp(1)-temp(4)) 0];
% % The z-vector is 
% a3 = [0 0 num_of_layers*delta_z];

%% Move the crystal such that the first atom lies at the specified x-y-z coords
coords = [coords(:,1)-coords(1,1)+x_pos, coords(:,2)-coords(1,2)+y_pos, coords(:,3)-coords(1,3)+z_pos];

clear l n pos sorted_3rd_col sorted_z_col x_y_coords delta_z temp num_of_layers

% vectors = [a1;a2;a3]
disp(['# of atoms: ' num2str(length(coords))])
coords
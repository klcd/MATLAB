%% Plot the x-y atom position from the CONTCAR file
function [coords,vectors]  = plot_atoms (file_name)

num_BN_layer = 2;
% num_Au_layer = 7;

[coords,vectors] = read_contcar(file_name);

%% Gold
figure
hold on
plot(coords{1,3}(1:3,1),coords{1,3}(1:3,2),'bx')
plot(coords{1,3}(4:6,1),coords{1,3}(4:6,2),'rx')
plot(coords{1,3}(7:9,1),coords{1,3}(7:9,2),'kx')
plot(coords{1,3}(10:12,1),coords{1,3}(10:12,2),'bo')

%% BN
figure
hold on
plot(coords{2,3}(1:4,1),coords{2,3}(1:4,2),'bo')
plot(coords{3,3}(1:4,1),coords{3,3}(1:4,2),'go')

%% Au - BN
figure
hold on
plot(coords{1,3}(1:3,1),coords{1,3}(1:3,2),'rx')
plot(coords{2,3}(1:4,1),coords{2,3}(1:4,2),'bo')
plot(coords{3,3}(1:4,1),coords{3,3}(1:4,2),'go')

%% Interlayer distance
figure
plot(sort(coords{1,3}(:,3)))
hold on
plot(sort(coords{2,3}(:,3)))
plot(sort(coords{3,3}(:,3)))
grid on

%% Print the interlayer distances
disp('Interlayer distances between the boron atoms:')
for ii=1:4:(length(coords{2,3}(:,3))-4)
    disp(sprintf('%1.5f',coords{2,3}(ii+4+2,3)-coords{2,3}(ii+2,3))) %#ok<DSPS>
end

disp('Interlayer distances between the nitrogen atoms:')
for ii=1:4:(length(coords{3,3}(:,3))-4)
    disp(sprintf('%1.5f',coords{3,3}(ii+4+2,3)-coords{3,3}(ii+2,3))) %#ok<DSPS>
end
% return
% close all
%% Expanded crystal
nx = 2; ny = 2;
coords = repeat_crystal(coords,vectors,nx,ny,0);
tmp = sortrows(coords{2,3},3);
figure
hold on
plot(tmp(1:end/num_BN_layer,1),tmp(1:end/num_BN_layer,2),'bo')
tmp = sortrows(coords{3,3},3);
plot(tmp(1:end/num_BN_layer,1),tmp(1:end/num_BN_layer,2),'go')
tmp = sortrows(coords{1,3},3);
plot(tmp(1:3*((nx+1)*(ny+1)),1),tmp(1:3*((nx+1)*(ny+1)),2),'rx')

% figure
% plot(coords{2,3}(:,1),coords{2,3}(:,2),'bo')
% figure
% plot(coords{3,3}(:,1),coords{3,3}(:,2),'go')

end
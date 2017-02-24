function [dx,dy,dz] = compare_contcars(contcar1,contcar2)
%Function to compare the same structure in cartesian cordinates when relaxed with different lattice
%constants or unit vectors.
%Takes the first atom and computes the distances two all other atoms in each direction for 2
%contcar files. Then takes the difference of these distances.
cords1 = read_contcar(contcar1);
cords2 = read_contcar(contcar2);

dx1 = cords1(:,1) - cords1(1,1);
dy1 = cords1(:,2) - cords1(1,2);
dz1 = cords1(:,3) - cords1(1,3);

dx2 = cords2(:,1) - cords2(1,1);
dy2 = cords2(:,2) - cords2(1,2);
dz2 = cords2(:,3) - cords2(1,3);

dx = dx1 - dx2
dy = dy1 - dy2
dz = dz1 - dz2
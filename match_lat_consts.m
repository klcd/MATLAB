function [smallest_match, a_new1, a_new2] = match_lat_consts(lat1,lat2,max,tol,prop)
%Finds multiples n1 and n2 of two lengths lat1 and lat2 such that n1*nlat1 =
%n2*lat2 where nlat1 and nlat2 are strained length with a strain lower
%than tol. Hereby n1 and n2 < max and the proportion prop relates to how the strain
%is distributed between lat1 and lat2. The strain is defined as s_i =
%(nlat_i-nlat_i)/lat_i and p = s1/s2.

%This function may be used to match two different primitive unit cells.



% lat1 = 3.1823;
% lat2 = 2.8064;
% max = 5;
% tol = 0.05;
% prop = 1;

n_matches = 0;

matches = zeros(1,2);
straines = zeros(1,2);
dlats = zeros(1,2);
for ii = 1:max;
    for jj = 1:max;
        
        diff = abs(ii*lat1 - jj*lat2);
        lat1_strain = (prop*diff)/(prop*ii*lat1+jj*lat2);
        lat2_strain = (diff)/(prop*ii*lat1+jj*lat2);
        
        if (lat1_strain < tol) & (lat2_strain < tol);
            matches(n_matches+1, 1) = ii;
            matches(n_matches+1, 2) = jj;
            straines(n_matches+1, 1) = lat1_strain;
            straines(n_matches+1, 2) = lat2_strain;
            dlats(n_matches+1,1) = lat1_strain*lat1;
            dlats(n_matches+1,2) = lat2_strain*lat2;
            n_matches = n_matches +1;
        end
    end
end

%Displaying the different matches
disp(['Number of matches ' num2str(n_matches)])
disp([matches straines])

%Evaluationg the smallest match
%disp('Evaluating smallest match')

smallest_match = matches(1,:);
dlat1 = dlats(1,1);
dlat2 = dlats(1,2);

%disp(['Matches ' num2str(smallest_match)])
%disp(['Change in lattice constant 1 ' num2str(dlat1)])
%disp(['Change in lattice constant 2 ' num2str(dlat2)])
%disp(['Old lattice constant 1 ' num2str(lat1)])
%disp(['Old lattice constant 2 ' num2str(lat2)])

if smallest_match(1)*(lat1+dlat1)-smallest_match(2)*(lat2-dlat2)<10^-4
    new_lat1 = lat1+dlat1;
    new_lat2 = lat2-dlat2;
elseif smallest_match(1)*(lat1-dlat1)-smallest_match(2)*(lat2+dlat2)<10^-4
   new_lat1 = lat1-dlat1;
   new_lat2 = lat2+dlat2;
elseif smallest_match(1)*(lat1+dlat1)-smallest_match(2)*(lat2+dlat2)<10^-4
   new_lat1 = lat1+dlat1;
   new_lat2 = lat2+dlat2; 
elseif smallest_match(1)*(lat1-dlat1)-smallest_match(2)*(lat2-dlat2)<10^-4
   new_lat1 = lat1-dlat1;
   new_lat2 = lat2-dlat2;
end

%disp(['New lattice constant 1 ' num2str(new_lat1)])
%disp(['New lattice constant 2 ' num2str(new_lat2)])
disp('The strains in the lattices are')
disp(['Lattice 1 ' num2str(1-new_lat1/lat1)]) 
disp(['Lattice 2 ' num2str(1-(new_lat2)/lat2)]) 


a_new1 = new_lat1;
a_new2 = new_lat2;

end

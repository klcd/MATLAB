fid = fopen('POSCAR');

% The first line is not interesting
fgetl(fid);
a = str2double(fgetl(fid));
% 3rd and fourth lines are not interesting too
fgetl(fid); fgetl(fid);
temp = textscan(fgetl(fid),'%f');
c = temp{1}(3)*a;
 
fclose(fid);
% 
% const_min = fmincon(@latticeEnergy, [a c],[],[],[],[],[a-0.1 c-0.5],[a+0.1 c+0.5]);
% 
% disp(['The crystal parameter minimizing the energy are: a = ' num2str(const_min(1)) ' and c = ' num2str(const_min(2))]);

a_range = -0.1:0.02:0.1;
c_range = -0.5:0.05:0.5;
E = size(length(a_range),length(c_range));

for ii=1:length(a_range)
    
    for jj=1:length(c_range)
        
        E(ii,jj) = latticeEnergy([a+a_range(ii) c+c_range(jj)]);
        
    end
end
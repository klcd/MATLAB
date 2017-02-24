%Banstructure Data

load 'wannier90_band.dat';
nr_bands = 11;
nr_kpoints = 238;
bands = ones(nr_kpoints,nr_bands+1);
bands(:,1) = wannier90_band(1:nr_kpoints,1); 
for i = 1:nr_bands
   bands(:,i+1) = wannier90_band(1+(i-1)*nr_kpoints:i*nr_kpoints,2);
    
end
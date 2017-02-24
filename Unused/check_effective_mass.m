no_valley=1;

%hbar=1.0546e-34;
hbar=6.58e-16;
e=1.6022e-19;
m0=9.1095e-31;

m=1e-9;

k=load('k.dat');
Nk=length(k);
dk=(k(2)-k(1));

for I=1:no_valley,
    
    filename=['Ekl_' num2str(I-1) '.dat'];
    Ek=load(filename);
    
   d2E_dk2=((Ek(1,(Nk+1)/2+2))+(Ek(1,(Nk+1)/2))-2*(Ek(1,(Nk+1)/2+1)))/dk^2;
   mstar=(d2E_dk2*1/hbar^2)^(-1)/m0*e/m^2
    
end


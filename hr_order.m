function H = hr_order(hr)
% convert the Hamiltonian obtained from Wannier90 to a 5-dimensional matrix

minx = min(hr(:,1));
maxx = max(hr(:,1));
Nx = maxx-minx+1;
miny = min(hr(:,2));
maxy = max(hr(:,2));
Ny = maxy-miny+1;
minz = min(hr(:,3));
maxz = max(hr(:,3));
Nz = maxz-minz+1;
NWF = max(hr(:,4));
H = zeros(Nx,Ny,Nz,NWF,NWF);

for var_i = 1:length(hr(:,1))
    l = hr(var_i,:);
    x = l(1) - minx + 1;
    y = l(2) - miny + 1;
    z = l(3) - minz + 1;
    wf1 = l(4);
    wf2 = l(5);
    re = l(6);
    %im = l(7);
    %just nullify the imaginary part.
    im = 0;
        
    H(x,y,z,wf1,wf2) = re + 1j * im;    
end

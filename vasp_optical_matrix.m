%Assembling the data

%Optical matrix elements
nbcon = 9;
nbval = 4;
direction = 3;
nkpt = 192;
load MAT_EL.dat

A = MAT_EL;
IM_p = A(:,2:2:8);
RE_p = A(:,1:2:7);



%Note that ISPIN from is not yet included in this script!!!

% kp = 2;
% dir = 1;
% start = ((kp-1)*nbcon*3+1)+((dir-1)*nbcon);
% ende = start+nbcon-1;
Im = zeros(nbcon,nbval,3,nkpt);
Re = zeros(nbcon,nbval,3,nkpt);
for ii = 1:nkpt
    for jj = 1:3
        start = ((ii-1)*nbcon*3+1)+((jj-1)*nbcon);
        ende = start+nbcon-1;
        Im(:,:,jj,ii) = IM_p(start:ende,:);
        Re(:,:,jj,ii) = RE_p(start:ende,:);
    end
end

clear start ende ii jj IM_p RE_p A


con = 1;
val = 1;

os_str = zeros(nkpt,3);
for jj = 1:3
    for ii = 1:nkpt
        os_str(ii,jj) = Re(con,val,jj,ii)^2 + Im(con,val,jj,ii)^2;
    end
end

clear ii jj

%Kpoints
fid = fopen('IBZKPT');
kpts = textscan(fid,'%f %f %f %f','headerLines',3);
fclose(fid)

kpts = [kpts{[1,2,3,4]}];

for i = 1:3
    kpts(kpts(:,i) < 0) = kpts(kpts(:,i) < 0) +1;
end

[B,~,a,~,~,~,~,~,~] = vasp_read_poscar('POSCAR')

Base = zeros(3,3);
Vol = sum(B(:,1).*cross(B(:,2),B(:,3)));
Base(:,1) = 1/a*cross(B(:,2),B(:,3))/Vol;
Base(:,2) = 1/a*cross(B(:,3),B(:,1))/Vol;
Base(:,3) = 1/a*cross(B(:,1),B(:,2))/Vol;

Kpts = zeros(nkpt,3);

for ii = 1:nkpt
    Kpts(ii,:) = (kpts(ii,1)*Base(:,1) +  kpts(ii,2)*Base(:,2) +  kpts(ii,3)*Base(:,3))';
end

%scatter(Kpts(:,1),Kpts(:,2), 50,os_str(:,3),'filled')
hold on
plot3(Kpts(:,1),Kpts(:,2),os_str(:,direction),'bo')


A = [Kpts(:,1), Kpts(:,2), os_str(:,direction)];

dlmwrite('Dat',A,' ')


%  
%  Kprotx = zeros(nkpt,3);
%  for ii = 1:nkpt
%      Kprotx(ii,:) = (rotx(180)*Kpts(ii,:)')';
%  end
%  
%  hold on
%  plot3(Kprotx(:,1),Kprotx(:,2),os_str(:,3),'x')
%  
%  Kprotz = zeros(nkpt,3);
%  for ii = 1:nkpt
%      Kprotz(ii,:) = (rotz(120)*Kpts(ii,:)')';
%  end
%  
%  hold on
%  plot3(Kprotz(:,1),Kprotz(:,2),os_str(:,3),'x')
% 
%   Kprotmz = zeros(nkpt,3);
%  for ii = 1:nkpt
%      Kprotmz(ii,:) = (rotz(240)*Kpts(ii,:)')';
%  end
%  
%  hold on
%  plot3(Kprotmz(:,1),Kprotmz(:,2),os_str(:,3),'.')
 

%Extract dielectric tensor from OUTCAR file and puts real and imaginary
%parts into the files repart and impart
frachem1 = 2*pi/(4.135667662*2.99792458)*10^-3;


if ~((exist('repart','file') == 2) && (exist('impart','file') == 2))   
    pattern1 = 'IMAGINARY DIELECTRIC FUNCTION';
    pattern2 = 'REAL DIELECTRIC FUNCTION';
    pattern3 = 'The outermost node in the dielectric function';
    
    %Searches all lines between the two specified pattern
    system(['awk ''/' pattern1 '/{p=1}; p; /' pattern2 '/ {p=0}''' ' OUTCAR > impart']);
    
    %Searches all lines between the two specified pattern
    system(['awk ''/' pattern2 '/{p=1}; p; /' pattern3 '/ {p=0}''' ' OUTCAR > repart']);   
end

%Puts dielectric real and imaginary part of the dielectric tensor into the
%cells C2 and C1
fid1 = fopen('impart');
C1 = textscan(fid1, '%f %f %f %f %f %f %f','headerLines',3);

fid2 = fopen('repart');
C2 = textscan(fid2, '%f %f %f %f %f %f %f','headerLines',3);


%If the material is 2D then the dielectric tensor has to be rescaled. Here
%the z axis from VASP must be the confined axis. Improvements would be
%possible here.

dim = 2;

if dim == 2
    [B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar();
    
    Lz = B(3,3)*a;
    
    if crystal == 1
        conf = B(3,3)*(max(Ap(3,:))-min(Ap(3,:)))*a;
    else
        conf = (max(Ap(3,:))-min(Ap(3,:)))*a;
    end
    
    conf = 1;
    
%     if conf > 0
%         for i = 2:7
%             C1{i} = C1{i}/(conf);
%             C2{i} = C2{i}/(conf);
%         end
%     end

end



%Calculation of the kappa, diffractive indexes and reflectivities.
kxx = sqrt((sqrt(C1{2} .* C1{2}+C2{2} .* C2{2})-C2{2})/2);
kyy = sqrt((sqrt(C1{3} .* C1{3}+C2{3} .* C2{3})-C2{3})/2);
kzz = sqrt((sqrt(C1{4} .* C1{4}+C2{4} .* C2{4})-C2{4})/2);

nxx = sqrt((sqrt(C1{2} .* C1{2}+C2{2} .* C2{2})+C2{2})/2);
nyy = sqrt((sqrt(C1{3} .* C1{3}+C2{3} .* C2{3})+C2{3})/2);
nzz = sqrt((sqrt(C1{4} .* C1{4}+C2{4} .* C2{4})+C2{4})/2); 

Rxx = ((nxx-1).*(nxx-1) + kxx.*kxx)./((nxx+1).*(nxx+1) + kxx.*kxx);
Ryy = ((nyy-1).*(nyy-1) + kyy.*kyy)./((nyy+1).*(nyy+1) + kyy.*kyy);
Rzz = ((nzz-1).*(nzz-1) + kzz.*kzz)./((nzz+1).*(nzz+1) + kzz.*kzz);


%figure
hold on
h = plot(C1{1},C1{2}*Lz,'-')
%h = plot(C1{1},1-exp(-frachem1*C1{1}.*C1{2}*Lz),'-')
%h2 = plot(C1{1},1-exp(-frachem1*C1{1}.*kxx*Lz),'b-')
hold on

box on
% xlabel('Photon Energy [eV]','Fontsize',20)
% ylabel('A(E)','Fontsize',20)
% title('Monolayer MoS_2 in IP','Fontsize',30)
 
xlim([0,3.5])

% [leg,legh] = legend( 'PBE + RPA')
% legh(1).FontSize = 9
% legh(2).LineWidth = 3
% leg.Position = leg.Position + [0 0 0 0.1]


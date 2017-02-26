function [ Amn ] = cat_projections(Nbands)

linenum = 4;
fid = fopen('KPOINTS');
KPTS=textscan(fid, '%s', 1, 'delimiter', '\n', 'headerlines', linenum-1);
KPTS=KPTS{1};
KPTS=KPTS{1};

KPTS=split_str(' ',KPTS);
k_i = zeros(1,3);
for var_i=1:3
    k_i(var_i)=str2num(KPTS{var_i});
end
Nkpts=k_i(1)*k_i(2)*k_i(3);
fclose(fid);

Num_wfs=load('parts.dat');
Nparts = length(Num_wfs);

ending = '/wannier90.amn';

files = cell(1,Nparts);
for var_i = 1:(Nparts);
    files{var_i} = ['part',int2str(var_i-1),ending];
end

Amn = zeros(sum(Num_wfs)*Nkpts*Nbands,5);

for var_i = 1:length(files)
    display(int2str(var_i))
    
    wfshift = sum(Num_wfs(1:var_i-1));
    startline = wfshift * Nkpts*Nbands+1;
    
    f = files{var_i};
    fid = fopen(f);
    fgetl(fid); fgetl(fid);
    A=textscan(fid,repmat('%f',1,5),'CollectOutput',true);
    
    A = A{1}(A{1}(:,1)<=Nbands & A{1}(:,2)<= Num_wfs(var_i),:);
    Amn(startline:startline+length(A(:,1))-1,:) = A;
    Amn(startline:startline+length(A(:,1))-1,2) = Amn(startline:startline+length(A(:,1))-1,2) + wfshift;
    
end

disp('Writing amn to file.')
Amn = sortrows(Amn,[3 2 1]);
A_header = ['Projections from Vasp, concatenated by Matlab.\n\t',int2str(Nbands),'\t',int2str(Nkpts),'\t',int2str(sum(Num_wfs)),'\n'];

fid = fopen('Amn', 'wt');
fprintf(fid,A_header);
fprintf(fid,'%.0f %.0f %.0f %.12f %.12f\n',Amn');

fclose(fid);


end


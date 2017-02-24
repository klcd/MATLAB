
function vasp_write_poscar(B,Ap,a,N,id,crystal, sel_dyn, dyn_tag, filename)
% function to write vasp poscar files
% CALL: write_poscar(B,Ap,a,N,id,crystal,filename)
%
% input args:
% - B: basis vectors for the lattice
% - Ap: atomic positions in basis B
% - a: lattice constant
% - N: number of atoms per type
% - id: cell array of identifier strings for each type
% - crystal: specify whether coordinates are in basis B or not 
% - filename: a name for the output file


%% bitching
if size(B,1)~=3 || size(B,2)~=3
    error('need size(B) == [3 3]')
end
if size(Ap,1)~=3
    error('need size(Ap) == [3 n]')
end
if sum(N)~=size(Ap,2)
    error('need sum(N) == size(Ap,2)')
end
% if length(id)~=0 && length(N)~=length(id)
%     error('need length(N) == length(id)')
% end


%% function body
fid = fopen(filename,'w');

fprintf(fid,[datestr(datetime('now')) '\n']);
fprintf(fid,'%f\n',a);
fprintf(fid,'%17.16f %17.16f %17.16f\n',B);

for c=1:size(id,2)
    fprintf(fid,'%s',id{c});
    if c<size(id,2)
        fprintf(fid,' ');
    else
        fprintf(fid,'\n');
    end
end
for c=1:length(N)
    fprintf(fid,'%i',N(c));
    if c<size(id,2)
        fprintf(fid,' ');
    else
        fprintf(fid,'\n');
    end
end

if sel_dyn
    fprintf(fid, 'Selective dynamics\n');
end

if crystal
    fprintf(fid,'Direct\n');
else
    fprintf(fid,'Cartesian\n');
end

if ~sel_dyn
    fprintf(fid,'%17.16f %17.16f %17.16f\n',Ap);
else
    for i = 1:size(Ap,2)
        fprintf(fid, '%17.16f %17.16f %17.16f ',Ap(:,i)');
        s = dyn_tag(:,i)';
        s = [s(1) ' ' s(2) ' ' s(3)];
        fprintf(fid, '%s\n',s);
    end
end
fclose(fid);

end
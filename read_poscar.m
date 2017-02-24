function [B,Ap,a,N,T,id,crystal] = read_poscar(filename)
% function to read data from POSCAR files
% CALL: [B,Ap,a,N,T,id,crystal] = read_poscar(filename)
%
% terminology:
% - Na: # of atoms in POSCAR
% - Nsp: # of atomic species in POSCAR
%
% input args:
% - filename: name of the POSCAR file, default: 'POSCAR'
%
% output args:
% - B: cell vectors as columns, size 3x3
% - Ap: atomic positions, size 3xNa
% - a: lattice constant
% - N: array of total number of atoms per species, size 1xNsp
% - T: array of atomic types, size 1xNa
% - id: cell array of strings, size 1xNsp
% - crystal: true if Ap are in crystal coordinates

%% default argument
if nargin<1
    filename = 'POSCAR';
end


%% open file
fid = fopen(filename);

fgets(fid);                                     % comment
a = sscanf(fgets(fid),'%lf',1);                 % lattice constant

B = zeros(3);
B(:,1) = sscanf(fgets(fid),'%lf %lf %lf',3);    % base vec 1
B(:,2) = sscanf(fgets(fid),'%lf %lf %lf',3);    % base vec 2
B(:,3) = sscanf(fgets(fid),'%lf %lf %lf',3);    % base vec 3

buff = fgets(fid);
if any(isstrprop(buff,'alpha'))
    id = strsplit(buff);
    id = id(~cellfun('isempty',id));        % read ids
    buff = fgets(fid);
else
    id = {};
end

N = strread(buff);                          % read Ntype
N = N(N~=0);
T= [];
for cnt=1:length(N)
    T = [T cnt*ones(1,N(cnt))];             % convert to type
end

sel_dyn = false;
buff = fgets(fid);                          % direct or cartesian flag
if (buff(1)=='s' || buff(1)=='S')
    sel_dyn = true;
    buff = fgets(fid);                      % skip Selective Dynamics
end
crystal = (buff(1)=='D'| buff(1) == 'd');

Ap = zeros(3,sum(N));
dyn_tag = char(ones(3,sum(N))*'T');

if sel_dyn
    for cnt=1:size(Ap,2)
        buff = fgets(fid);
        Ap(:,cnt) = sscanf(buff,'%lf %lf %lf',3);   % pos cnt
        dyn_tag(:,cnt) = sscanf(buff,'%*lf %*lf %*lf %[T,F] %[T,F] %[T,F]',3);
        
    end
else
    for cnt=1:size(Ap,2)
        buff = fgets(fid);
        Ap(:,cnt) = sscanf(buff,'%lf %lf %lf',3);   % pos cnt
    end      
end

end
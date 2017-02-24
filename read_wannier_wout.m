function [B,R,Wp,s,Apf,Apc,T,id,Na,Nw] = read_wannier_wout(filename)
% function ro read hamiltonian data from wannier90 output
% CALL: [B,R,Wp,s,Apf,Apc,T,id,Na,Nw] = read_wannier_wout(filename)
%
% input args:
% - filename: name of the wannier90 wout file, default: 'wannier90.wout'
%
% output args:
% - B: lattice vectors as columns, size 3x3
% - R: reciprocal space vectors, size 3x3
% - Wp: wannier centers as columns, size 3xNw
% - s: spread for each wannier function, size 1xNw
% - Apf: atomic positions in fractional as columns, size 3xNa
% - Apc: atomic positions in cartesian as columns, size 3xNa
% - T: atomic type, size 1xNa
% - id: atomic identifiers, size 1xunique(Na)
% - Na: # atomic positions
% - Nw: # wannier functions


%% default argument
if nargin<1
    filename = 'wannier90.wout';
end


%% open file
fid = fopen(filename);


%% read B, R
buff = fgets(fid);
while isempty(strfind(buff,'Lattice Vectors'))
    buff = fgets(fid);
end

B = zeros(3);
for cb=1:3
    buff = fgets(fid);
    B(:,cb) = sscanf(buff,'%*s %lf %lf %lf');
end

fgets(fid);
fgets(fid);
fgets(fid);
fgets(fid);

R = zeros(3);
for cr=1:3
    buff = fgets(fid);
    R(:,cr) = sscanf(buff,'%*s %lf %lf %lf');
end


%% read Apf, Apc, T, id, Na
fgets(fid);
fgets(fid);
fgets(fid);
fgets(fid);
Apf=[]; Apc=[]; T = []; id = {};

buff = fgets(fid);
while (buff(2)=='|')
    % id, T
    sbuff = sscanf(buff,'%*s %s',1);
    
    found = false;
    for cc=1:length(id)
        if strcmp(sbuff,id{cc})
            T = [T cc];
        end
    end
    if ~found
        id{length(id)+1} = sbuff;
        T = [T length(id)];
    end
    
    % Apf Apc
    Apf = [Apf sscanf(buff,'%*s %*s %*i %lf %lf %lf',3)];
    Apc = [Apc sscanf(buff,'%*s %*s %*i %*lf %*lf %*lf %*s %lf %lf %lf',3)];
    
    buff = fgets(fid);
end

Na = size(Apf,2);


%% read Wp, s, Nw
buff = fgets(fid);
while isempty(strfind(buff,'Number of Wannier Functions'))
    buff = fgets(fid);
end
Nw = sscanf(buff,'%*s %*s %*s %*s %*s %*s %lf',1);


buff = fgets(fid);
while isempty(strfind(buff,'Final State'))
    buff = fgets(fid);
end

Wp = zeros(3,Nw); s=zeros(1,Nw);
for cw=1:Nw
    buff = fgets(fid);
    lfbuff = sscanf(buff,'%*s %*s %*s %*s %*lf %*c %lf %*c %lf %*c %lf %*c %lf',4);
    Wp(:,cw) = lfbuff(1:3)';
    s(cw) = lfbuff(4);
end


end
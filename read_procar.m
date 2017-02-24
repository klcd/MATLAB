function [k,B,w,Nk,Nb,Ni] = read_procar(filename)
% function to read PROCAR files from VASP
% CALL: [k,B,w,Nk,Nb,Ni] = read_procar(filename)
%
% input args:
% - filename: filename of the PROCAR file, default 'PROCAR'
%
% output args:
% - k: kpoints, size 3xNk
% - B: band data, array of length Nk, each element holds:
%   - E: energies in eV for each k-point, size 1xNb
%   - occ: occupation of state in E, size 1xNb
%   - s,p,d,...: orbital projection coefficients, size NixNb
% - w: weights, a weight factor for each kpoint, size 1xNk
% - Nk: # of kpoints in PROCAR
% - Nb: # of bands in PROCAR
% - Ni: # of ions in PROCAR


%% default argument
if nargin<1
    filename = 'PROCAR';
end

%% open file and get mode
fid = fopen(filename);
buff = fgets(fid);
if ~isempty(strfind(buff,'new format'))
    mode = 1;
    format = '%*i %lf %lf %lf %lf';
end
if ~isempty(strfind(buff,'lm decomposed + phase'))
    mode = 2;
    format = '%*i %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf';
end


%% read metadata
% buff = fgets(fid);
% N = sscanf(buff,'%*s %*s %*s %i %*s %*s %*s %i %*s %*s %*s %i');
buff = strsplit(fgets(fid),':');
Nk=sscanf(buff{2},'%i',1); Nb=sscanf(buff{3},'%i',1); Ni=sscanf(buff{4},'%i',1);

%% initialize data
k = zeros(3,Nk);
w = zeros(1,Nk);

for ck=1:Nk
    fgets(fid);

    % kpoint and weight
    buff = fgets(fid);
    dat = sscanf(buff,'%*s %*i %*s %lf %lf %lf %*s %*s %lf');
    k(:,ck) = dat(1:3);
    w(ck) = dat(4);
    
    % initialize data
    B(ck).E = zeros(1,Nb);
    B(ck).occ = zeros(1,Nb);
    
    B(ck).s = zeros(Ni,Nb);
    B(ck).p = zeros(Ni,Nb);
    B(ck).d = zeros(Ni,Nb);
    B(ck).tot = zeros(Ni,Nb);
    if mode==2
        B(ck).px = zeros(Ni,Nb);
        B(ck).py = zeros(Ni,Nb);
        B(ck).pz = zeros(Ni,Nb);
        B(ck).dxy = zeros(Ni,Nb);
        B(ck).dyz = zeros(Ni,Nb);
        B(ck).dxz = zeros(Ni,Nb);
        B(ck).dz2 = zeros(Ni,Nb);
        B(ck).dx2 = zeros(Ni,Nb);
    end

    for cb = 1:Nb
        fgets(fid);

        % energy and occupation
%         buff = fgets(fid);
%         dat = sscanf(buff,'%*s %*i %*s %*s %lf %*s %*s %lf');
        buff = strsplit(fgets(fid),'#');
        dat = [sscanf(buff{2},'%*s %lf') sscanf(buff{3},'%*s %lf')];
        B(ck).E(cb) = dat(1);
        B(ck).occ(cb) = dat(2);


        fgets(fid);
        fgets(fid);
        % projections for each ion
        for ci=1:Ni
            buff = fgets(fid);
            
            dat = sscanf(buff,format);
            
            B(ck).s(ci,cb) = dat(1);
            B(ck).tot(ci,cb) = dat(end);
            
            if mode==1
                B(ck).p(ci,cb) = dat(2);
                B(ck).d(ci,cb) = dat(3);
            end
            if mode==2
                B(ck).py(ci,cb) = dat(2);
                B(ck).pz(ci,cb) = dat(3);
                B(ck).px(ci,cb) = dat(4);
                B(ck).dxy(ci,cb) = dat(5);
                B(ck).dyz(ci,cb) = dat(6);
                B(ck).dz2(ci,cb) = dat(7);
                B(ck).dxz(ci,cb) = dat(8);
                B(ck).dx2(ci,cb) = dat(9);
            end
        end
        fgets(fid); % tot ... line
        
        if mode==2
            % read phase spam
            for cc=1:2*ci+1
                fgets(fid);
            end
        end
    end
    
    if mode==2
        B(ck).p = B(ck).px+B(ck).py+B(ck).pz;
        B(ck).d = B(ck).dxy+B(ck).dyz+B(ck).dxz+B(ck).dz2+B(ck).dx2;
    end
    
    fgets(fid);
end

fclose(fid);

end
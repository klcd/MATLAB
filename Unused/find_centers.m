function [ atom ] = find_centers(unit_cell_vectors,exclude_wfs)
% Find the closest atoms (in the "home" or nearest neighbour unit cells) 
% to the Wannier function centers. Exclude the "exclude_wfs" Wannier
% functions and atoms that don't have any WFs centered on them.

uc=unit_cell_vectors;
r1 = 1;  % max periodic replicas along the three unit cell vectors
r2 = 1;
r3 = 1;

% read in the wannier90_centres.xyz file. Two lines of header.

f = 'wannier90_centres.xyz';
fid=fopen(f);
C=textscan(fid,'%d',1);
numlines=C{1};
fgetl(fid);
fgetl(fid);
C=textscan(fid,'%s%f%f%f',numlines);
Atext=C{1};
A=[C{2} C{3} C{4}];

% count the WFs (marked with X in the file) and the atoms

Natoms=0;
Nwf=0;

% in case some WFs should be excluded, Nwf will not be the same as the
% number of lines that should be skipped to get to the atom coordinates.

skip=0;

% counting

for var_i=1:length(Atext)
    if (strcmp(Atext{var_i},'X'))
        if (~ismember(var_i,exclude_wfs))
            Nwf=Nwf+1;
        else
            skip=skip+1;
        end
    else
        Natoms=Natoms+1;
        atom(Natoms).wfs=0;
        atom(Natoms).coord=A(var_i,:);
        atom(Natoms).type=Atext{var_i};
    end
end

% lines that hold WFs that are not excluded:

wf_lineindices=(1:Nwf+skip);
wf_lineindices=wf_lineindices(~ismember(wf_lineindices,exclude_wfs));

% WF coordinates

wfs = A(wf_lineindices,:);

% atom coordinates

atomcoords = A((Nwf+1+skip):end,:);

% create periodic images, find the closest atom for each WF

for var_wf = 1:Nwf
        wf_pos = wfs(var_wf,:);
        
        %set the distance to the closest atom to something very large
        %initially
        
        mindist = 1e5; 
        
        % index of the closest atom
        
        minind = 0;
        
        % periodic replicas along the three lattice vectors
        
        for xr = -r1:r1
            for yr = -r2:r2
                for zr = -r3:r3
                    
                    % distance of the wannier function from all the
                    % different atoms in this unit cell (as a matrix
                    % holding the difference of the coordinates)
                    
                    dist_mx = atomcoords + repmat([xr yr zr]*uc-wf_pos,Natoms,1);
                    
                    % norm of those vectors
                    
                    dist_vect = dist_mx(:,1).*dist_mx(:,1) + dist_mx(:,2).*dist_mx(:,2) + dist_mx(:,3).*dist_mx(:,3);
                    
                    % find the smallest distance
                    
                    [dist, ind] = min(abs(dist_vect));
                    
                    % check if it is smaller than in the previous unit
                    % cells
                    
                    if (dist < mindist)
                        mindist = dist;
                        minind = ind;
                    end
                end
            end
        end
        
        
        % append the index of the WF to the apropriate element of the atom
        % struct
        
        if (atom(minind).wfs(1)==0)
            atom(minind).wfs(1)=wf_lineindices(var_wf);
        else
            atom(minind).wfs(end+1)=wf_lineindices(var_wf);
        end
end

% remove those atoms that don't have any WFs centered on them

var_j=1;
for var_i=1:Natoms
    if (atom(var_i).wfs(1)~=0)
        atom_tmp(var_j)=atom(var_i);
        var_j=var_j+1;
    end
end
atom=atom_tmp;

Natoms=length(atom);
types = cell(Natoms,1);
wf_numbers=zeros(Natoms,1);
types{1}=atom(1).type;
wf_numbers(1)=length(atom(1).wfs);
for var_j=2:Natoms
    types{var_j}='';
end
for var_j=2:Natoms
    type=atom(var_j).type;
    Nwf=length(atom(var_j).wfs);
    if (~ismember(type,types))
        types{var_j}=type;
        wf_numbers(var_j)=Nwf;
    else
        ind_type=find(ismember(types,type),1,'first');
        if (wf_numbers(ind_type) ~= Nwf)
            display('Warning! Different number of WFs on the same atom types:')
            display(['index 1: ',num2str(ind_type),' type 1: ', types{ind_type}, ' WFs 1: ', num2str(wf_numbers(ind_type)), ' coords 1: ',num2str(atom(ind_type).coord)])
            display(['index 2: ',num2str(var_j),' type 2: ', atom(var_j).type, ' WFs 2: ', num2str(Nwf), ' coords 2: ',num2str(atom(var_j).coord)])
        end
    end    
end
end


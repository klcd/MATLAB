function [sc] = make_rectangular_supercell(atom,unit_cell_vectors,sc_vectors,axes,miny,corner)
% create the atom and unit_cell blocks table corresponding to the supercell
% starting from corner=[x0 y0 z0], with sc_vectors being the lattice
% vectors of the supercell in terms of the u.c. lattice vectors 
% (first:transport axis, second:confined axis, third:periodic axis). "atom" is
% the list of the atoms in the unit cell. "maxneighbours" is a 1x3 vector
% with the number of neigbhbours that has to be considered along the 3 unit
% cell vectors to create the supercell. axes(1): transport direction,
% axes(2) confined direction, axes(3) periodic direction (eg. axes=[1
% 2 3]

% unit cell volume

V_uc = cross(unit_cell_vectors(1,:),unit_cell_vectors(2,:))*unit_cell_vectors(3,:)';

sc_abs_vectors=sc_vectors*unit_cell_vectors;

% supercell volume

V_sc = sc_abs_vectors(:,3)' * cross(sc_abs_vectors(:,1),sc_abs_vectors(:,2));

% number of primitive cells

N_uc = abs(round(V_sc/V_uc));

display(['Number of primitive unit cells in the supercell: ',num2str(V_sc/V_uc)]);

% number of atoms in the unit cell

uc_NA = length(atom);

% number of atoms in the supercell

sc_NA = uc_NA * N_uc;



% If the origin is not defined by the corner variable, find the atom with
% the smallest y coord that is above miny

if (~exist('corner','var'))

    mincoord=miny+sc_abs_vectors(axes(2),:)*sc_abs_vectors(axes(2),:)';
    minind=1;
    for var_i = 1:length(atom)                
        c=atom(var_i).coord;
        if (c(axes(2))< mincoord && c(axes(2))>miny)
            mincoord=c(axes(2));
            minind = var_i;
        end
    end               
    corner1=atom(minind).coord;
else
    corner1=corner;
end

% the maximum of the x,y,z coordinates of the supercell

corner2=corner1+[1 1 1]*sc_abs_vectors;

% atoms very close to the edges of the cell are repositioned within this
% distance

tolerance = 1e-5;

% blocks (unit cells) in the supercell

blockind=0;

% atoms in the supercell

var_sc_atom=0;

Nwf = 0; % counts the total number of wf-s in the supercell. 

% start from first neighbor cells at first

maxneighbors =0;

% save what neighbors have been already checked

neighbors = [0 0 0];

% we will need to make one step in the loop at least

first = 1;

% this loop creates replicas along each unit cell vectors, repositons the
% atoms close to the edges, and checks if the atom is inside the supercell
% volume. The block struct holds the vector pointing to that specific unit
% cell, in terms of the unit cell lattice vectors, and stores the atom
% indices that are within that block. Depending on the origin, the same
% supercell can contain different number of unit cells with different
% number of atoms in those cells.

while var_sc_atom < sc_NA
    display(['Searching... maximum of neighbor cells: ',num2str(maxneighbors)])
    for r1=-maxneighbors:maxneighbors
        for r2=-maxneighbors:maxneighbors
            for r3=-maxneighbors:maxneighbors
                
                % check whether this replica has been already considered
                
                if (~ismember([r1 r2 r3],neighbors,'rows') || first)
                    
                    first = 0;
                    
                    % vector pointing to this unit cell
                    
                    vect=[r1 r2 r3]*unit_cell_vectors;
                    
                    % initialize the next element of the block struct and set
                    % its coordinate
                    
                    blockind=blockind+1;
                    block(blockind).atoms(1)=0;
                    block(blockind).lat_vect=[r1 r2 r3];
                    
                    % loop through all atoms in this unit cell
                    
                    for var_a=1:length(atom)
                        
                        a=atom(var_a);
                        
                        % coordinate in the supercell
                        
                        c=a.coord+vect;
                        
                        % if it is very close to the edge, position it to the edge
                        % exactly
                        
                        if (c(1)<corner1(1) && c(1)>=corner1(1)-tolerance)
                            c(1)=corner1(1);
                        end
                        if (c(2)<corner1(2) && c(2)>=corner1(2)-tolerance)
                            c(2)=corner1(2);
                        end
                        if (c(3)<corner1(3) && c(3)>=corner1(3)-tolerance)
                            c(3)=corner1(3);
                        end
                        if (c(1)<=corner2(1) && c(1)>corner2(1)-tolerance)
                            c(1)=corner2(1);
                        end
                        if (c(2)<=corner2(2) && c(2)>corner2(2)-tolerance)
                            c(2)=corner2(2);
                        end
                        if (c(3)<=corner2(3) && c(3)>corner2(3)-tolerance)
                            c(3)=corner2(3);
                        end
                        
                        % transform this change back into the primitive unit cell
                        
                        atom(var_a).coord=c-vect;
                        
                        % check whether all coordinates are larger than the first
                        % corner's and smaller than the second one's. I.e: the atom
                        % is inside the supercell volume.
                        
                        if (~ismember(0,c-corner1>=0) && ~ismember(0,c-corner2<0))
                            
                            % count the atoms in the supercell
                            
                            var_sc_atom=var_sc_atom+1;
                            
                            % save the current atom struct as the next element of
                            % the supercell's atom
                            
                            sc.atom(var_sc_atom)=a;
                            
                            % Count the total number of WFs
                            
                            Nwf=Nwf+length(a.wfs);
                            
                            % save the index of the atom in the unit cell into the
                            % actual block struct
                            
                            if (block(blockind).atoms(1)==0)
                                block(blockind).atoms(1)=var_a;
                            else
                                block(blockind).atoms(end+1)=var_a;
                            end
                        end
                    end
                    
                    neighbors = [neighbors; r1 r2 r3];
                    
                end
            end
        end
    end    
    maxneighbors = maxneighbors + 1;    
end
% the last index of the atoms is the total number of atoms

display('Supercell created');

NA = var_sc_atom;

%remove empty blocks

b=1;
for blockind=1:length(block)
    if (block(blockind).atoms(1)~=0)
        block_tmp(b)=block(blockind);
        b=b+1;
    end
end

% Number of WFs in one unit cell

Nwf_uc=0;
for var_i=1:length(atom)
    Nwf_uc = Nwf_uc + length(atom(var_i).wfs);
end

% save everything into the sc (supercell) struct

uc.Nwf=Nwf_uc;
sc.block=block_tmp;
axis(1).vect=unit_cell_vectors(1,:);
axis(2).vect=unit_cell_vectors(2,:);
axis(3).vect=unit_cell_vectors(3,:);
uc.axis=axis;
uc.atom=atom;
uc.unit_cell_vectors=unit_cell_vectors;
uc.NA=length(uc.atom);
sc.uc=uc;
sc.sc_vectors=sc_vectors;
sc.sc_abs_vectors=sc_abs_vectors;
sc.transport_axis.lat_vect = sc_vectors(1,:);
sc.periodic_axis.lat_vect = sc_vectors(3,:);
sc.confined_axis.lat_vect = sc_vectors(2,:);
sc.transport_axis.vect = sc_abs_vectors(1,:);
sc.periodic_axis.vect = sc_abs_vectors(3,:);
sc.confined_axis.vect = sc_abs_vectors(2,:);
sc.Nwf = Nwf;
sc.NA = NA;
sc.axes=axes;


end

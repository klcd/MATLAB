function [NN_t,NN_p, NN_y] = getmaxNNs(sc,r_cut)
% determine how many neighbors of the supercell are required in the
% transport- and the periodic directions at the given interaction range.

% supercell lattice vector lengths

L_t = sqrt(sc.transport_axis.vect * sc.transport_axis.vect');
L_p = sqrt(sc.periodic_axis.vect * sc.periodic_axis.vect');
L_y = sqrt(sc.confined_axis.vect * sc.confined_axis.vect');

% initialize the minimum and maximum coordinate values

min_trans = inf;
min_period = inf;
min_y = inf;
max_trans = -inf;
max_period = -inf;
max_y = -inf;

% number of unit cells

Nblocks = length(sc.block);

% find the smallest and largest x, y, and z coordinates of the atoms in the
% supercell

for IB=1:Nblocks
    block = sc.block(IB);
    NA_per_block=length(block.atoms);
    for IA = 1:NA_per_block
        atom = sc.uc.atom(block.atoms(IA));
        t_coord = (atom.coord + block.lat_vect*sc.uc.unit_cell_vectors) * sc.transport_axis.vect' / L_t;
        p_coord = (atom.coord + block.lat_vect*sc.uc.unit_cell_vectors) * sc.periodic_axis.vect' / L_p;
        y_coord = (atom.coord + block.lat_vect*sc.uc.unit_cell_vectors) * sc.confined_axis.vect' / L_y;
        if (t_coord < min_trans)
            min_trans = t_coord;
        end
        if (t_coord > max_trans)
            max_trans = t_coord;
        end
        if (p_coord < min_period)
            min_period = p_coord;
        end
        if (p_coord > max_period)
            max_period = p_coord;
        end
        if (y_coord < min_y)
            min_y = y_coord;
        end
        if (y_coord > max_y)
            max_y = y_coord;
        end
    end
end

% the distance between the largest atom coordinates and the smallest ones
% in the first replicas

d_t = L_t - (max_trans - min_trans);
d_p = L_p - (max_period - min_period);
d_y = L_y - (max_y - min_y);

% The number of neighbors required to hold all the interactions within
% r_cut range is not simply 1 + r_cut/L because there is some additional
% space between the last and first atoms that might reduce the requirements.

NN_t = floor((r_cut-d_t)/L_t) + 1;
NN_p = floor((r_cut-d_p)/L_p) + 1;
NN_y = floor((r_cut-d_y)/L_y) + 1;

end


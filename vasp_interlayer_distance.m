function[d]  = vasp_interlayer_dist(filename) 

if nargin<1
    filename = 'POSCAR';
end

[B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar(filename);


dist = sort(Ap(3,:));


if(crystal == 1)
    d = (dist(4)-dist(3))*B(3,3)*a;
else
    d = (dist(4)-dist(3))*a;
end

end
load ep_xx.mat;
load ep_yy.mat;

scale = 1;
eps = (ep_xx + ep_yy)./2;


minO = vasp_check_keyword('OPTCTR','OMIN',1);
maxO = vasp_check_keyword('OPTCTR','OMAX',1);
nedos = size(eps,2);

[B,Ap,a,N,T,id,crystal,sel_dyn, dyn_tag] = vasp_read_poscar(); 
Lz = B(3,3)*a;
eps = eps*Lz;

ens = linspace(minO,maxO,nedos);


epsi = sum(eps,1);
%figure
hold on
plot(ens,scale*epsi,'-')
xlim([0,3.5])
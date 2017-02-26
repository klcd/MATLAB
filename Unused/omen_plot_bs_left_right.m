load CB_k.dat
load CB_Ekr.dat
load VB_k.dat
load VB_Ekr.dat

load CB_k.dat
load CB_Ekl.dat
load VB_k.dat
load VB_Ekl.dat


cb_max = max([max(CB_Ekl(:)) max(CB_Ekr(:))]);
vb_min = min([min(VB_Ekl(:)) min(VB_Ekr(:))]);

subplot(1,2,1)
plot(CB_k,CB_Ekl,'b')
hold on
plot(VB_k,VB_Ekl,'b')
hold off
axis([-pi pi vb_min cb_max])
set(gca,'Xtick', [ -pi, -pi/2, 0 ,pi/2, pi])
set(gca,'XtickLabel',{'\pi', '\pi/2', '0', '\pi/2', '\pi'})

subplot(1,2,2)
plot(CB_k,CB_Ekr,'r')
hold on 
plot(VB_k,VB_Ekr,'r')
hold off
axis([-pi pi vb_min cb_max])
set(gca,'Xtick', [ -pi, -pi/2, 0 ,pi/2, pi])
set(gca,'XtickLabel',{'\pi', '\pi/2', '0', '\pi/2', '\pi'})
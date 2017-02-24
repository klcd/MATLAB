figure
load CB_Ekl.dat
load CB_k.dat
load VB_Ekl.dat
plot(CB_k,CB_Ekl,'b.')
hold on
plot(CB_k,VB_Ekl,'r.')

figure
load CB_Ekr.dat
load CB_k.dat
load VB_Ekr.dat
plot(CB_k,CB_Ekr,'b.')
hold on
plot(CB_k,VB_Ekr,'r.')

% figure
% load CB_Ekl.dat
% load CB_k.dat
% load VB_Ekl.dat
% ind = ceil(length(CB_k)*0.5);
% en = max(VB_Ekl(:));
% plot(CB_k(ind:end),CB_Ekl(:,ind:end)-en,'b.')
% hold on
% plot(CB_k(ind:end),VB_Ekl(:,ind:end)-en,'r.')

isequaltol([CB_Ekl;VB_Ekl],[CB_Ekr;VB_Ekr],1e-4)
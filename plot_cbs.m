function [ ] = plot_cbs( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load Lx.dat
load kE_0.dat
load E_0.dat

n_of_modes=length(kE_0(1,:))/2;

kE_0=kE_0(:,1:2:2*n_of_modes)+1i*kE_0(:,2:2:2*n_of_modes);
kE_0=kE_0/Lx;

%% Additional
tol = 5e-2;

load kE_0.dat

kE_re = kE_0(:,1:2:2*n_of_modes)/Lx;
kE_im = kE_0(:,2:2:2*n_of_modes)/Lx;
kE_re(abs(kE_re)<tol) = NaN;
kE_im(abs(kE_im)<tol) = NaN;
figure
hold all
plot(-abs(kE_im),E_0,'b.')
plot(abs(kE_re),E_0,'r.')

%% Additional
% figure
% plot(-abs(imag(kE_0)),E_0,'b.',abs(real(kE_0)),E_0,'r.')


end


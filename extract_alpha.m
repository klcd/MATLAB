%% Comment

% extract the effective mass, non-parabolicity factor alpha(1rst order) 
% from Fullband bandstructure results

% clear all


%% no. bands

subb=2;     % number subbands

value(1)=1.96e19;     % limit where to extract the bandstructure
value(2)=4e18;

value(3)=4e18;
value(4)=4e18;

%% PARAMETERS

e=1.6022e-19; % unit charge
hbar=1.0546e-34; % in J*s
hbarev=hbar/e;
kB=8.6173324e-5;    % Boltzmann's constant in eV/K
T=300;  % Temperature in K
m0=9.1095e-31; % electron rest mass in kg
dx=0.2e-9;
no_valley=1;
m=1e9;


%% BETA equation

syms alph1 alph2 bet1 bet2 Em EMA1 E1
eqn= E1 + alph1 * (E1-Em)^2 + bet1 * (E1-Em)^3 == EMA1;
eqn2= E1 + alph2 * (E1-Em)^2 + bet2 * (E1-Em)^3 == EMA1;
% eqn2= E1 + alph * (E1)^2 + bet1 * (E1)^3 + Em == EMA1;
solE=solve(eqn,E1);
solE2=solve(eqn2,E1);
% solE2=solve(eqn2,E1);

%% FOLDER

% cd /home/aziegler/00-Projekte/03-Research/00-Non-parabolicity/01-2_alpha-approach/00-UTB/00-OMEN_results/Lg_5nm/Vds_06
%cd /home/aziegler/00-Projekte/03-Research/00-Non-parabolicity/02-Alpha_Beta_approach/01-2D_double_gate/00-OMEN_results/10nm_confinement


% load ../7.5nm_confinement/Lx.dat
% CB_Ekl=load('CB_Ekr.dat')*e;
[~ , CB_Ekl] = read_eigenval();
CB_Ekl = CB_Ekl(65:end,:)*e;
%CB_k=load('CB_k.dat')/m/Lx;
% load Lx.dat
Lx = 6.083600000000012*0.1;
% CB_Ekl = CB_Ekl(:,1:10:end);
CB_k = linspace(-pi/Lx*m,pi/Lx*m,length(CB_Ekl(1,:)));

% 
% E_0=load ('E_0.dat');
% load kE_0.dat
% 
% n_of_modes=length(kE_0(1,:))/2;
% 
% kE_0=kE_0(:,1:2:2*n_of_modes)+1i*kE_0(:,2:2:2*n_of_modes);
% kE_0=kE_0/Lx*m;



% load  /home/aziegler/00-Projekte/03-Research/00-Non-parabolicity/02-Alpha_Beta_approach/00-FinFet/01-QTS_results/Ekl_0.dat
% load  /home/aziegler/00-Projekte/03-Research/00-Non-parabolicity/02-Alpha_Beta_approach/00-FinFet/01-QTS_results/k.dat

for ii=1:subb
    
    %Ekl(ii,:) = interp1(k*m, Ekl_0(ii,:)*e-min(Ekl_0(ii,:)*e), CB_k,'linear');

    % CB_Ek(ii,:)=CB_Ekl(2*ii-1,:);
    CB_Ek(ii,:)=CB_Ekl(ii,:);
    [Emin(ii),ind_kmin(ii)]=min(CB_Ek(ii,:));


%     ind=find(abs(imag(kE_0(:,ii)))>10);
%     k_complex =  (abs(imag(kE_0(ind,ii))))';
% 
%     E_complex = E_0(ind);
% 
%     [kcmax,ind_kcmax] = max(k_complex);
%     k_complex1{ii}=k_complex(ind_kcmax:end);
%     E_complex1{ii}=(E_complex(ind_kcmax:end))*e; %-Emin(ii)/e))*e;
end


% for BB=4:subb
%     
% CB_Ek(BB,1:(length(CB_Ekl)+1)/2)=CB_Ekl(2*BB-1,1:(length(CB_Ekl)+1)/2);
% CB_Ek(BB,(length(CB_Ekl)+1)/2+1:length(CB_Ekl))=CB_Ekl(2*BB,(length(CB_Ekl)+1)/2+1:length(CB_Ekl));
% 
% [Emin(BB),ind_kmin]=min(CB_Ek(BB,:));
% 
% end





k2=CB_k.^2;

%% FIT effective mass

dk=(CB_k(ind_kmin(1)+1)-CB_k(ind_kmin(1)-1))/2;
d2Ek_dk2=(CB_Ek(1,ind_kmin(1)+1)+CB_Ek(1,ind_kmin(1)-1)-2*CB_Ek(1,ind_kmin(1)))/dk^2;
meff=hbar^2/d2Ek_dk2/m0; % effective mass [no unit]
c1=2*meff*m0/hbar^2;



%% FIT ALPHA

indx=find(CB_k.^2<value(1));
a=CB_Ek(1,indx)-Emin(1);
b=CB_k(indx).^2;

[xData, yData] = prepareCurveData(a,b);
ft = fittype('poly2');
opts = fitoptions( ft );
opts.Upper = [10/e*c1 c1 0];
opts.Lower = [-10/e*c1 c1 0];
[np_fit, gof] = fit( xData, yData, ft, opts );
np_fit_coef=coeffvalues(np_fit);

alpha=np_fit_coef(1)/c1; 
alpha2=alpha;

% fitting curve 1
figure
plot(k2(ind_kmin:end),CB_Ek(1,ind_kmin:end)/e)
hold on
plot(b,CB_Ek(1,indx)/e,'g','linewidth',2)
xlabel('k^2 [m^{-1}]')
ylabel('E [eV]')

% fitting curve 2
figure
plot(a,b,'--')
hold on
plot(a,alpha2*c1*a.^2+a*c1,'r')
ylabel('Energy [J]')
xlabel('k^2 [m^{-2}]')
legend('BS Data','2nd order polynomial fit')

%% Quantities


fprintf('meff : %.4g\n',meff)
fprintf('alpha: %.4g\n',alpha2*e)

figure
plot(CB_k,CB_Ekl-min(min(CB_Ekl)),'.')
hold on
plot(CB_k,CB_k.^2*hbar^2/(2*meff*m0))


% save('meff_alpha.mat')

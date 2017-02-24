%clear all
%load Test.mat
Base = vasp_brioullin_base('POSCAR');
%names = repmat(name_nr,12,1);
nb_val = 18;
val = 18;
con = 1;
dist = 0.1
Test = prep_trans_data(val,con,nb_val);

conts = min(Test(:,3)):0.2:max(Test(:,3));
%Takes the data in Test organised in 2 colums of x and y coordinates of k
%points and a third column of the data at theses kpoints. Then restores the
%original BZ from the IBZ and interpolates the data with fft.

%original data


%rotating the data
rm120 = (rotz(-120)*Test')'+ repmat((Base(:,1)+Base(:,2))',size(Test,1),1);
r120 = (rotz(120)*Test')'+ repmat((Base(:,1))',size(Test,1),1);

Dat1 = [Test;r120;rm120];

c1 = Dat1 + repmat((-1/3*Base(:,2)-2/3*Base(:,1))',size(Dat1,1),1);
m1 = [-c1(:,1) c1(:,2) c1(:,3)];

Dat2 = [c1;m1];
m2 = [Dat2(:,1) -Dat2(:,2) Dat2(:,3)] + repmat(((Base(:,2)-Base(:,1))./3)',size(Dat2,1),1);

Dat = [[Dat2;m2]+repmat((1/3*Base(:,2)+2/3*Base(:,1))',size(Dat2,1)+size(m2,1),1)];

clear rm120 r120 Dat1 c1 m1 Dat2 m2;





Dat_frac = sortrows(unique(round([Dat(:,1:2)*inv([Base(1:2,1) Base(1:2,2)])' Dat(:,3)],8),'rows'),[1,2]);
% hold on
length(Dat_frac);


X = reshape(Dat_frac(:,1),sqrt(length(unique(Dat_frac,'rows'))),[]);
Y = reshape(Dat_frac(:,2),sqrt(length(unique(Dat_frac,'rows'))),[]);
E = reshape(Dat_frac(:,3),sqrt(length(unique(Dat_frac,'rows'))),[]);


nr_points = 203;
%g = surf(X,Y,E)
%set(g,'FaceColor',[0 1 0],'FaceAlpha',0.5);
[Xi,Yi]=  meshgrid(linspace(0,1,nr_points),linspace(0,1,nr_points));
Inter = fftInterpolate(E,[nr_points,nr_points]);



%Back to cartesian coordinates
Xi_new = Xi*Base(1,1) + Yi*Base(1,2);
Yi_new = Xi*Base(2,1) + Yi*Base(2,2); 

%%%%%%%%%%%%%%plots%%%%%%%%%%%%%%%%%%%55555

%h = surf(Xi,Yi,Inter)
%set(h,'FaceColor',[1 0 0],'FaceAlpha',0.5,'LineStyle','none');


%Generating the new contour labels.
figure
[c,~] = contour(Xi_new,Yi_new,Inter,conts,'k','ShowText','on');
tl = clabel(c, 'FontSize', 10);
itvec = 2:2:length(tl);
NewCoutours = zeros(size(itvec));
for i= itvec
    textstr = get(tl(i), 'String');
    NewCoutours(i) = round(str2double(textstr), 1);
end



h = pcolor(Xi_new,Yi_new,Inter);
colormap('jet')
set(h,'EdgeColor','none');
hold on;
contour(Xi_new,Yi_new,Inter, NewCoutours,'k', 'ShowText','on');
daspect([1,1,1]);
set(gca,'Xtick',[],'Ytick',[]);

%function to plot the nanowire cross section

a0=0.543;                %width of the nanowire unit cell along the x-axis

load Layer_Matrix.dat

xmin=min(Layer_Matrix(:,1));

ind=find(abs(Layer_Matrix(:,1)-xmin)<(a0-1e-6));

figure(1)
hold on

for IA=1:length(ind),
    for IB=5:length(Layer_Matrix(1,:)),
        if Layer_Matrix(IA,IB)>0,
            bond_vec=Layer_Matrix(Layer_Matrix(IA,IB),1:3)-Layer_Matrix(IA,1:3);
            plot([Layer_Matrix(IA,2) Layer_Matrix(IA,2)+bond_vec(2)],[Layer_Matrix(IA,3) Layer_Matrix(IA,3)+bond_vec(3)],'k')
        end
    end
end

for IA=1:length(ind),
    plot(Layer_Matrix(IA,2),Layer_Matrix(IA,3),'r.','MarkerSize',16)
end
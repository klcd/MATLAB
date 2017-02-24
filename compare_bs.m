load vbands.xy;
load wannier90_band.dat;

E_Fermi = -.2800;

new_vbands(:,1) = vbands(:,1)*max(wannier90_band(:,1))/max(vbands(:,1));
new_vbands(:,2) = vbands(:,2) + E_Fermi;


plot(new_vbands(:,1),new_vbands(:,2), 'or')
hold on
plot(wannier90_band(:,1),wannier90_band(:,2), 'ob')
hold off


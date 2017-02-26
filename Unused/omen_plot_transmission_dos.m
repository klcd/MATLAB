load MCB_E_0.dat
load MCB_TEl_0.dat
load MCB_ZEl_0.dat
load MVB_E_0.dat
load MVB_TEl_0.dat
load MVB_ZEl_0.dat

subplot(1,2,1)
plotyy(MCB_E_0,MCB_TEl_0,MCB_E_0,MCB_ZEl_0)
subplot(1,2,2)
plotyy(MVB_E_0,MVB_TEl_0,MVB_E_0,MVB_ZEl_0)
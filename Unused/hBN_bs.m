au_wf = 24*36*6;
hBN_block_wf = 4*96*2;

wf_l = au_wf+1:au_wf+hBN_block_wf;
wf_m = wf_l(end)+1:wf_l(end)+hBN_block_wf;
wf_r = wf_m(end)+1:wf_m(end)+hBN_block_wf;

if exist('Hblocks','var')
   % do nothing
elseif exist('H.mat','file')
    load H.mat
else
    Hblocks{1,1} = load_binary_Hamiltonian('H_0.bin');
    Hblocks{1,2} = load_binary_Hamiltonian('H_3.bin');
    Hblocks{1,3} = load_binary_Hamiltonian('H_6.bin');
    Hblocks{2,1} = load_binary_Hamiltonian('H_1.bin');
    Hblocks{2,2} = load_binary_Hamiltonian('H_4.bin');
    Hblocks{2,3} = load_binary_Hamiltonian('H_7.bin');
    Hblocks{3,1} = load_binary_Hamiltonian('H_2.bin');
    Hblocks{3,2} = load_binary_Hamiltonian('H_5.bin');
    Hblocks{3,3} = load_binary_Hamiltonian('H_8.bin');
    save('H.mat','Hblocks');
end
[k,Ek] = compute_bandstrucure(Hblocks.',[],wf_m,wf_r,wf_l);

figure
plot(k(1,:),Ek,'b') %,'.b','MarkerSize',3')
title('Band structure of hBN in transport direction.')
xlabel('k')
ylabel('Energy [eV]')
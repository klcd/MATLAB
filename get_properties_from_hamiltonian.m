%% load the hamiltonian
if exist('Hblocks','var')
   % do nothing
elseif exist('H.mat','file')
    load H.mat
%     Hblocks = squeeze(Hblocks_full_whole  (2,:,:));
else
    red = 0;
    if red
        ending = '_reduced.bin';
    else
        ending = '.bin';
    end
    Hblocks{1,1} = load_binary_Hamiltonian(['H_0' ending]);
    Hblocks{1,2} = load_binary_Hamiltonian(['H_3' ending]);
    Hblocks{1,3} = load_binary_Hamiltonian(['H_6' ending]);
    Hblocks{2,1} = load_binary_Hamiltonian(['H_1' ending]);
    Hblocks{2,2} = load_binary_Hamiltonian(['H_4' ending]);
    Hblocks{2,3} = load_binary_Hamiltonian(['H_7' ending]);
    Hblocks{3,1} = load_binary_Hamiltonian(['H_2' ending]);
    Hblocks{3,2} = load_binary_Hamiltonian(['H_5' ending]);
    Hblocks{3,3} = load_binary_Hamiltonian(['H_8' ending]);
    save('H.mat','Hblocks');
end

%% right contact
if 1
au_wf = 24*36*6;
hBN_block_wf = 4*96*2;
wf_l = au_wf+1+hBN_block_wf:au_wf+2*hBN_block_wf;
wf_m = wf_l(end)+1:wf_l(end)+hBN_block_wf;
wf_r = wf_m(end)+1:wf_m(end)+hBN_block_wf;

% au_wf = 40*12*6;
% hBN_block_wf = 2*32*2;
% wf_l = au_wf+hBN_block_wf*9.5+1:au_wf+hBN_block_wf*10.5;
% wf_m = au_wf+hBN_block_wf*10.5+1:au_wf+hBN_block_wf*11.5;
% wf_r = au_wf+hBN_block_wf*11.5+1:au_wf+hBN_block_wf*12.5;

% hBN_block_wf = 4*60*2;
% wf_l = 1:hBN_block_wf;
% wf_m = wf_l(end)+1:wf_l(end)+hBN_block_wf;
% wf_r = wf_m(end)+1:wf_m(end)+hBN_block_wf;

Nk = 50;
[k_hBN,Ek_hBN] = compute_bandstrucure(Hblocks.',[],wf_m,wf_r,wf_l,'line',Nk);
% [k_hBN_im,Ek_hBN_im] = compute_bandstrucure_im(Hblocks.',[],wf_m,wf_r,wf_l,'line',Nk);

figure
plot(k_hBN(1,:),Ek_hBN,'b')
title('Band structure of hBN in transport direction.')
xlabel('k')
ylabel('Energy [eV]')

% figure
% plot([fliplr(k_hBN_im(1,:)) k_hBN(1,:)],[fliplr(Ek_hBN_im) Ek_hBN],'b')
% title('Band structure of hBN in transport direction.')
% xlabel('k')
% ylabel('Energy [eV]')
end

%% left contact
if 0
au_wf_block = 6*36*6;
au_atom_block = 6*36;
% au_atom_block = 12*3;
% au_wf_block = 12*3*6;

wf_l = 1:au_wf_block;
wf_m = au_wf_block+1:2*au_wf_block;
wf_r = 2*au_wf_block+1:3*au_wf_block;

Nk = 5;
[k_Au,Ek_Au] = compute_bandstrucure(Hblocks.',[],wf_m,wf_r,wf_l,'grid',Nk);

k_plot_ind = find(k_Au(2,:)==0 & k_Au(3,:)==0);

figure
plot(k_Au(1,k_plot_ind),Ek_Au(:,k_plot_ind),'b')
title('Band structure of Au in transport direction.')
xlabel('k')
ylabel('Energy [eV]')
end
if 1
%% band diagram
Ef_Au = get_Fermi_level(au_atom_block*11,Ek_Au)
cb_hBN = min(min(Ek_hBN(Ek_hBN>Ef_Au)));
vb_hBN = max(max(Ek_hBN(Ek_hBN<Ef_Au)));

sc = load_structure_params();
figure
plot([0 sc.left_L]*1e-1,[Ef_Au Ef_Au])
hold on
plot([sc.left_L sc.left_L+sc.right_L]*1e-1,[cb_hBN vb_hBN;cb_hBN vb_hBN],'r')
plot([sc.left_L sc.left_L]*1e-1,[cb_hBN+1 vb_hBN-1],'k')
xlim([0 sc.left_L+sc.right_L]*1e-1)
title('Band diagram')
xlabel('x [nm]')
ylabel('Energy [eV]')
ylim([vb_hBN-1 cb_hBN+1])
text(sc.left_L*0.1,(cb_hBN+Ef_Au)*0.5,['\leftarrow band offset: ' num2str(cb_hBN-Ef_Au,3) 'eV'])
text(sc.left_L*0.1,(vb_hBN+Ef_Au)*0.5,['\leftarrow band offset: ' num2str(vb_hBN-Ef_Au,3) 'eV'])
text(sc.left_L*0.05,cb_hBN+0.5,'Au','HorizontalAlignment','center')
text(sc.left_L*0.1+sc.right_L*0.05,cb_hBN+0.5,'hBN','HorizontalAlignment','center')
legend('Fermi energy in the gold','Band edges','location','southwest')
%% effective masses in hBN
% [me,mh,cbe,vbe] = effective_mass(Ek_hBN, k_hBN(1,:), Ef_Au, 'right')
nvb = sum(Ek_hBN(:,1)<Ef_Au);
me = effective_mass(k_hBN(1,:),Ek_hBN(nvb+1,:));
mh = effective_mass(k_hBN(1,:),Ek_hBN(nvb,:),'h');
end


fig = openfig('bs.fig');


EFermi = -2;
range = 3;
Edir = '1.25'
Eind = '1.04'

axis([0 150 EFermi-range EFermi+range])
title(' Bandstructure','FontSize',30)
ylabel(' Energy [eV]','FontSize',20)


set(gca,'XTick',[0 50 100 150]')
set(gca,'XTickLabel',['K';'G';'M';'K'])


axesHandles = findall(fig,'type','axes')
plotpos = get(axesHandles,'position')
set(axesHandles,'position', plotpos - [0 0 plotpos(3)*0.05 plotpos(4)*0.05])



lh=findall(gcf,'tag','');
%set(lh,'location','northeastoutside');
pos_leg = get(lh,'position')




h = 0.125

%textbox = annotation('textbox',[pos_leg(1), pos_leg(2)-0.03-h, pos_leg(3), h], 'String', ['E_{dir}=' Edir ' E_{ind}=' Eind])
%set(textbox,'BackgroundColor','w')

function [] = export_images()
%% Export the image 
picturewidth = 20; % set this parameter and keep it forever
hw_ratio = 0.65; % feel free to play with this ratio
set(findall(groot, 'Type','figure','-property','FontSize'),'FontSize',17) % adjust fontsize to your document
set(findall(groot, 'Type','figure','-property','Box'),'Box','off') % optional
set(findall(groot, 'Type','figure','-property','Interpreter'),'Interpreter','latex')
set(findall(groot, 'Type','figure','-property','TickLabelInterpreter'),'TickLabelInterpreter','latex')
set(findall(groot, 'Type','figure'),'Units','centimeters','Position',[3 3 picturewidth hw_ratio*picturewidth])
pos = get(findall(groot, 'Type','figure'),'Position');
set(findall(groot, 'Type','figure'),'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])
print(findall(groot, 'Type','figure'),'-dpdf','-painters','-fillpage')
%print(hfig,fname,'-dpng','-painters');
end


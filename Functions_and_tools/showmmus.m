function [a] = showmmus(disp,dimx,dimy,a,b,fdt,ind)
%simple funtion to plot MMUS image
%showmmus(disp,dimx,dimy,a,b,fdt,ind)
%disp = displacement map
%dimx = lateral dimension vector
%dimy = axial dimension vector
%a = inferior limit of colorbar (um)
%b = superior limit of colorbar (um)
%fdt = 1/fr (fr = image framerate) (ms)
%ind = frame index desired

imagesc(dimx,dimy,19.5*disp(:,:,ind),[a b]);
set(gca,'fontsize',15)
axis image
xlabel('Lateral(mm)','fontsize',15)
ylabel('Depth(mm)','fontsize',15)
colormap jet
g = colorbar;
ylabel(g,'Displacement \mum','fontsize',15)
colormap ();
%set(gca, 'visible', 'off')
title(sprintf('Displacement at %1.1f ms',ind*fdt));
end

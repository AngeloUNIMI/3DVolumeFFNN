function [K,v] = convhull_fun(XLff, YLff, ZLff),

fs = 13;
[K,v] = convhulln([XLff' YLff' ZLff']);
trisurf(K,XLff,YLff,ZLff)


set(gca,'YDir','reverse');
set(gca,'ZDir','reverse')
xlabel('X [mm]','FontSize',fs);
ylabel('Y [mm]','FontSize',fs);
zlabel('Z [mm]','FontSize',fs);
title('3-D Convex Hull ','FontSize',fs);
axis equal tight
rotate3d on
grid off
set(gcf, 'color', 'white');
%axis off
%axis([min(XL) max(XL) min(YL) max(YL) min(ZL) max(ZL)])
set(gca,'FontSize',fs)
view(-113,24)


fprintf(1,'\nVolume: %.2f mm^3\n',v);
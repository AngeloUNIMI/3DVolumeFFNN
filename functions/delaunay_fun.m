function [tri,vol,area] = delaunay_fun(X,Y,Z,show)


%[Z isort] = sort(Z);
%Y = Y(isort);
%X = X(isort);

if(show)
    figure,
    fs = 13;
    scatter3(X,Y,Z,30,'r','filled')
    set(gca,'YDir','reverse');
    set(gca,'ZDir','reverse')
    xlabel('X [mm]','FontSize',fs);
    ylabel('Y [mm]','FontSize',fs);
    zlabel('Z [mm]','FontSize',fs);
    title('Point Cloud','FontSize',fs);
    axis equal tight
    rotate3d on
    grid off
    set(gcf, 'color', 'white');
    %axis off
    %axis([min(XL) max(XL) min(YL) max(YL) min(ZL) max(ZL)])
    set(gca,'FontSize',fs)
    view(-113,24)
end



tri = delaunay(X,Y,Z);
%trisurf(tri,X,Y,Z);


[vol,area]  = triangulationVolume(tri,X,Y,Z);


if(show)
    figure,
    fs = 13;
    trisurf(tri,X,Y,Z);
    set(gca,'YDir','reverse');
    set(gca,'ZDir','reverse')
    xlabel('X [mm]','FontSize',fs);
    ylabel('Y [mm]','FontSize',fs);
    zlabel('Z [mm]','FontSize',fs);
    title('Filtered Point Cloud','FontSize',fs)
    axis equal tight
    rotate3d on
    grid off
    set(gcf, 'color', 'white');
    %axis off
    axis([min(X) max(X) min(Y) max(Y) min(Z) max(Z)])
    set(gca,'FontSize',fs)
    view(-113,24)
    
end
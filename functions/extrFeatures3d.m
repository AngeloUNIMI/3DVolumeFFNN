function [problem] = extrFeatures3d(X, Y, Z, nXp, v, showMode)


v_direct_pc = alphavol([X' Y' Z'],Inf,0);


%Axes (bounding ellipsoid)
P = [X' Y' Z']';
K = convhulln(P');
K = unique(K(:));
Q = P(:,K);

[A, c] = MinVolEllipse(Q, .01);

[U, Q, V] = svd(A);

%the radii are given by:
r1 = 1/sqrt(Q(1,1));
r2 = 1/sqrt(Q(2,2));
r3 = 1/sqrt(Q(3,3));

%sort radii
vt = [r1 r2 r3];
vt2 = sort(vt);
r1 = vt(1);
r2 = vt(2);
r3 = vt(3);


[xe,ye,ze] = ellipsoid(c(1),c(2),c(3),r3,r2,r1,20);


if(showMode)
    fs = 13;
    figure,
    scatter3(X,Y,Z,20,'r','filled')
    hold on
    surf(xe,ye,ze)
    set(gca,'YDir','reverse');
    set(gca,'ZDir','reverse')
    xlabel('X [mm]','FontSize',fs);
    ylabel('Y [mm]','FontSize',fs);
    zlabel('Z [mm]','FontSize',fs);
    title('3D Bounding ellipsoid','FontSize',fs);
    axis equal tight
    rotate3d on
    grid off
    set(gcf, 'color', 'white');
    %axis off
    %axis([min(XL) max(XL) min(YL) max(YL) min(ZL) max(ZL)])
    set(gca,'FontSize',fs)
    view(-113,24)
    pause
end



%ratio of axes
rat1 = r1 / r2;
rat2 = r1 / r3;
rat3 = r2 / r3;



%sphere fitting
[cent, rad, resd] = spherefit(X,Y,Z);


%differenza tra raggio e distanza punti dal centro
distV = [];
for ii=1:numel(X)
    dd = eudistance(cent,[X(ii) Y(ii) Z(ii)]');
    dd2 = abs(dd - rad);
    distV = [distV dd2];
end

minD = min(distV);
maxD = max(distV);
meanD = mean(distV);
stdD = std(distV);



%boundaries della point cloud
minX = min(X);
meanX = mean(X);
maxX = max(X);
minY = min(Y);
meanY = mean(Y);
maxY = max(Y);
minZ = min(Z);
meanZ = mean(Z);
maxZ = max(Z);





%interpolazione funzione del piano
[xData, yData, zData] = prepareSurfaceData( X(1:end-nXp+1), Y(1:end-nXp+1), Z(1:end-nXp+1) );

% Set up fittype and options.
ft = fittype( 'poly11' );
opts = fitoptions( ft );
opts.Lower = [-Inf -Inf -Inf];
opts.Upper = [Inf Inf Inf];

% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft, opts );
%Linear model Poly11:
%     f(x,y) = p00 + p10*x + p01*y
p00 = fitresult.p00;
p10 = fitresult.p10;
p01 = fitresult.p01;





input = [v_direct_pc r1 r2 r3 rat1 rat2 rat3 minD maxD meanD stdD p00 p10 p01]';
%input = [r1 r2 r3 rat1 rat2 rat3 minD maxD meanD stdD p00 p10 p01]';
%input = [r1 r2 r3]';
target = v;


problem.s = input;
problem.t = target;






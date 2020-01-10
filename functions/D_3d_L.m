function [XLff, YLff, ZLff, XLp, YLp, ZLp, XLp2, YLp2, ZLp2, XL, YL, ZL] = D_3d_L(imA, CCCLr, CCCLm, CCCLrf, CCCLmf, CCCL3r, CCCL3m, dx, ...
    om,T,fc_left, cc_left, kc_left, alpha_c_left, fc_right, cc_right, kc_right, alpha_c_right, ...
    fileA, dirSaveModel, showMode, savepc)

fs = 13;

imAgray = rgb2gray(imA);



%punti del piano
Lp = CCCL3r';
Rp = CCCL3m';



%triangoliamo
[Xc_1_left,Xc_1_right] = stereo_triangulation(Lp,Rp,om,T,fc_left, ...
    cc_left,kc_left,alpha_c_left,fc_right,cc_right,kc_right,alpha_c_right);




%visualizziamo
XLp = Xc_1_left(1,:);
YLp = Xc_1_left(2,:);
ZLp = Xc_1_left(3,:);
XRp = Xc_1_right(1,:);
YRp = Xc_1_right(2,:);
ZRp = Xc_1_right(3,:);



%cambio di unità di misura in mm
XLp = XLp*dx./100;
YLp = YLp*dx./100;
ZLp = ZLp*dx./100 + 3.8;
XRp = XRp*dx./100;
YRp = YRp*dx./100;
ZRp = ZRp*dx./100 + 3.6;

[XLp,Is] = shuffle(XLp);
YLp = YLp(Is);
ZLp = ZLp(Is);




%nuvola non  filtrata
Lp = CCCLr';
Rp = CCCLm';



%triangoliamo
[Xc_1_left,Xc_1_right] = stereo_triangulation(Lp,Rp,om,T,fc_left, ...
    cc_left,kc_left,alpha_c_left,fc_right,cc_right,kc_right,alpha_c_right);




%visualizziamo
XLu = Xc_1_left(1,:);
YLu = Xc_1_left(2,:);
ZLu = Xc_1_left(3,:);
XRu = Xc_1_right(1,:);
YRu = Xc_1_right(2,:);
ZRu = Xc_1_right(3,:);



%cambio di unità di misura in mm
XLu = XLu*dx;
YLu = YLu*dx;
ZLu = ZLu*dx;
XRu = XRu*dx;
YRu = YRu*dx;
ZRu = ZRu*dx;
xlabel_s = sprintf('Asse X [mm]');
ylabel_s = sprintf('Asse Y [mm]');
zlabel_s = sprintf('Asse Z [mm]');



XLu = XLu/100;
YLu = YLu/100;
ZLu = ZLu/100;
XRu = XRu/100;
YRu = YRu/100;
ZRu = ZRu/100;


%interpolazione funzione del piano
[xData, yData, zData] = prepareSurfaceData( XLp, YLp, ZLp );

% Set up fittype and options.
ft = fittype( 'poly11' );
opts = fitoptions( ft );
opts.Lower = [-Inf -Inf -Inf];
opts.Upper = [Inf Inf Inf];

% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft, opts );
%Linear model Poly11:
%     f(x,y) = p00 + p10*x + p01*y



%eliminiamo i punti sotto al piano (con Z maggiore del piano)
indpianrem = [];
for sp = 1:size(XLu,2)
    zp = fitresult.p00 + fitresult.p10*XLu(sp) + fitresult.p01*YLu(sp);
    if ZLu(sp) > zp
        indpianrem = [indpianrem sp];
    end
end
XLu(:,indpianrem) = [];
YLu(:,indpianrem) = [];
ZLu(:,indpianrem) = [];



if showMode
    figure,
    scatter3(XLu,YLu,ZLu,30,'r','filled')
    hold on
    scatter3(XLp,YLp,ZLp,5,'g','filled')
    set(gca,'YDir','reverse');
    set(gca,'ZDir','reverse')
    xlabel('X [mm]','FontSize',fs);
    ylabel('Y [mm]','FontSize',fs);
    zlabel('Z [mm]','FontSize',fs);
    title('Unfiltered Point Cloud','FontSize',fs);
    axis equal tight
    rotate3d on
    grid off
    set(gcf, 'color', 'white');
    %axis off
    %axis([min(XL) max(XL) min(YL) max(YL) min(ZL) max(ZL)])
    set(gca,'FontSize',fs)
    view(-113,24)
    pause(2)
end






Lp = CCCLrf';
Rp = CCCLmf';



%triangoliamo
[Xc_1_left,Xc_1_right] = stereo_triangulation(Lp,Rp,om,T,fc_left, ...
    cc_left,kc_left,alpha_c_left,fc_right,cc_right,kc_right,alpha_c_right);




%visualizziamo
XL = Xc_1_left(1,:);
YL = Xc_1_left(2,:);
ZL = Xc_1_left(3,:);
XR = Xc_1_right(1,:);
YR = Xc_1_right(2,:);
ZR = Xc_1_right(3,:);



%cambio di unità di misura in mm
XL = XL*dx;
YL = YL*dx;
ZL = ZL*dx;
XR = XR*dx;
YR = YR*dx;
ZR = ZR*dx;
xlabel_s = sprintf('Asse X [mm]');
ylabel_s = sprintf('Asse Y [mm]');
zlabel_s = sprintf('Asse Z [mm]');



XL = XL/100;
YL = YL/100;
ZL = ZL/100;
XR = XR/100;
YR = YR/100;
ZR = ZR/100;


%eliminiamo i punti sotto al piano (con Z maggiore del piano)
indpianrem = [];
for sp = 1:size(XL,2)
    zp = fitresult.p00 + fitresult.p10*XL(sp) + fitresult.p01*YL(sp);
    if ZL(sp) > zp
        indpianrem = [indpianrem sp];
    end
end
XL(:,indpianrem) = [];
YL(:,indpianrem) = [];
ZL(:,indpianrem) = [];



%raffinamento punti del piano in base alla funzione fittata
XLp2 = [];
YLp2 = [];
ZLp2 = [];

for sp = 1:size(XL,2)
    zp = fitresult.p00 + fitresult.p10*XL(sp) + fitresult.p01*YL(sp);
    XLp2 = [XLp2 XL(sp)];
    YLp2 = [YLp2 YL(sp)];
    ZLp2 = [ZLp2 zp];
end






if showMode
    figure,
    scatter3(XL,YL,ZL,30,'r','filled')
    hold on
    scatter3(XLp2,YLp2,ZLp2,5,'g','filled')
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
    %axis([min(XL) max(XL) min(YL) max(YL) min(ZL) max(ZL)])
    set(gca,'FontSize',fs)
    view(-113,24)
    pause(2)
end






[XLff, YLff, ZLff, ip] = func_despike_phasespace3d_3var( XL, YL, ZL, 1 );

if showMode
    figure,
    scatter3(XLff,YLff,ZLff,30,'r','filled')
    hold on
    scatter3(XLp,YLp,ZLp,5,'g','filled')
    set(gca,'YDir','reverse');
    set(gca,'ZDir','reverse')
    xlabel('X [mm]','FontSize',fs);
    ylabel('Y [mm]','FontSize',fs);
    zlabel('Z [mm]','FontSize',fs);
    title('Filtered with Function Point Cloud','FontSize',fs)
    axis equal tight
    rotate3d on
    grid off
    set(gcf, 'color', 'white');
    %axis off
    %axis([min(XLff) max(XLff) min(YLff) max(YLff) min(ZLff) max(ZLff)])
    set(gca,'FontSize',fs)
    view(-113,24)
    pause(2)
end






if(0)
    %scale/shift per avere la stessa scala/posizione dell'immagine
    [ia ja] = find(maskAe);
    
    roiX = max(ja)-min(ja);
    pcX = max(XL)-min(XL);
    
    scaleFac = roiX / pcX;
    
    XLc = XL .* scaleFac;
    YLc = YL .* scaleFac;
    ZLc = ZL .* scaleFac;
    
    %shiftiamo
    diffX = 1280 - max(XLc);
    XLc = XLc + diffX;
    diffY = max(ia) - max(YLc);
    YLc = YLc + diffY;
    diffZ = min(ZL) - min(ZLc);
    ZLc = ZLc + diffZ;
    
    
    %invertiamo asse
    ZLc = ZLc .* -1 ;
    ZLc = ZLc - min(ZLc) - max(ZLc);
end



%interpolazione per upsampling?

if(1)
    [ZL, isort] = sort(ZL);
    YL = YL(isort);
    XL = XL(isort);
    
    ZL = smooth(ZL,5);
    
    [ZL, isort] = shuffle(ZL);
    YL = YL(isort);
    XL = XL(isort);
    
    
    
    x = XL'; % Some x coordinates
    y = YL';
    z = ZL';
    t = (1:size(x,1))'; % Index vector for the sampled points
    s = num2str(t); % To label the points
    ti = (1:0.2:size(x,1))'; % The interpolated values of t
    XLi = interp1(t,x,ti,'linear'); % Interpolated values of xi at ti.
    YLi = interp1(t,y,ti,'linear');
    ZLi = interp1(t,z,ti,'linear');
end



if(0)
    figure,
    scatter3(XLi,YLi,ZLi,5,'b','filled')
    set(gca,'YDir','reverse');
    set(gca,'ZDir','reverse')
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    axis equal tight
    rotate3d on
    grid off
    view(38,40)
    pause(2)
end




%xBL = [XL XLb];
%yBL = [YL YLb];
%zBL = [ZL ZLb];



xBL = [XL];
yBL = [YL];
zBL = [ZL];
%zBL = ZLc .* -1;


punti = 100;
passogrid1 = (max(xBL)-min(xBL)) / punti;
passogrid2 = (max(yBL)-min(yBL)) / punti;
gx=[min(xBL):passogrid1:max(xBL)];
gy=[min(yBL):passogrid2:max(yBL)];


g = gridfit(xBL,yBL,zBL,gx,gy, ...
    'smooth',150, ...
    'interp','triangle', ...
    'solver','normal', ...
    'regularizer','gradient', ...
    'extend','warning', ...
    'tilesize',inf);




[gx, gy] = meshgrid(gx,gy);

%invertiamo asse e spostiamo
%g = g - max(g(:)) - min(g(:));


if(0)
    imTex = uint8(zeros(size(imA,1),size(imA,2),3));
    
    
    imTex(:,:,1) = uint8(double(imA(:,:,1)) .* maskAe);
    imTex(:,:,2) = uint8(double(imA(:,:,2)) .* maskAe);
    imTex(:,:,3) = uint8(double(imA(:,:,3)) .* maskAe);
    i1 = find(imTex(:,:,1) == 0);
    t = imTex(:,:,1);
    t(i1) = 255;
    imTex(:,:,1) = t;
    
    i1 = find(imTex(:,:,2) == 0);
    t = imTex(:,:,2);
    t(i1) = 255;
    imTex(:,:,2) = t;
    
    i1 = find(imTex(:,:,3) == 0);
    t = imTex(:,:,3);
    t(i1) = 255;
    imTex(:,:,3) = t;
    
    
    
    
    immap = imTex(min(CCCLrf(:,2)):max(CCCLrf(:,2)),min(CCCLrf(:,1)):max(CCCLrf(:,1)),:);
    
    
    
    
    figure(),
    h1=surf(gx,gy,g, 'FaceColor','texturemap','EdgeColor','none','Cdata',...
        immap,'AlphaData',double(maskAe));
    alpha(1)
    set(gca,'YDir','reverse');
    set(gca,'ZDir','reverse');
    rotate3d on
    axis equal
    xlabel('X [mm]','FontSize',fs);
    ylabel('Y [mm]','FontSize',fs);
    zlabel('Z [mm]','FontSize',fs);
    title('Wrapped Image','FontSize',fs)
    grid off
    view(-113,24)
    set(gcf, 'color', 'white');
    %axis off
    axis([min(XL) max(XL) min(YL) max(YL) min(ZL) max(ZL)])
    set(gca,'FontSize',fs)
    pause(2)
    if (savepc), saveas(gcf,[dirSaveFig '\' fileA(end-10:end-6) '_leftsurf.fig']); end,
end




if(0)
    %scale/shift per avere la stessa scala/posizione dell'immagine
    [ia ja] = find(maskAe);
    
    roiX = max(ja)-min(ja);
    pcX = max(XL)-min(XL);
    
    scaleFac = roiX / pcX;
    
    XLc = XL .* scaleFac;
    YLc = YL .* scaleFac;
    ZLc = ZL .* scaleFac;
    
    %shiftiamo
    diffX = 1280 - max(XLc);
    XLc = XLc + diffX;
    diffY = max(ia) - max(YLc);
    YLc = YLc + diffY;
    diffZ = min(ZL) - min(ZLc);
    ZLc = ZLc + diffZ;
    
    
    %invertiamo asse
    ZLc = ZLc .* -1 ;
    ZLc = ZLc - min(ZLc) - max(ZLc);
    
    
    
    punti = 100;
    passogrid1 = (max(XLc)-min(XLc)) / punti;
    passogrid2 = (max(YLc)-min(YLc)) / punti;
    gxa=[min(XLc):passogrid1:max(XLc)];
    gya=[min(YLc):passogrid2:max(YLc)];
    ga = gridfit(XLc,YLc,ZLc,gxa,gya, ...
        'smooth',50, ...
        'interp','triangle', ...
        'solver','normal', ...
        'regularizer','gradient', ...
        'extend','warning', ...
        'tilesize',inf);
    [gxa gya] = meshgrid(gxa,gya);
    
    %upsampled surface for computations
    gx2 = imresize(gxa,3);
    gy2 = imresize(gya,3);
    g2 = imresize(ga,3);
    
    ix = find(gx2 > 1280);
    gx2(ix) = 1280;
    ix = find(gx2 < 1);
    gx2(ix) = 1;
    ix = find(gy2 > 960);
    gy2(ix) = 960;
    ix = find(gy2 < 1);
    gy2(ix) = 1;
    
    
    
    
    %calcolo delle normali alla superficie
    [Nx,Ny,Nz] = surfnorm(gx2,gy2,g2);
    %quelle vicino ai bordi le facciamo come quelle un po' più interne
    %Nx(1:20,:) = repmat(Nx(21,:),20,1);
    %Nx(end-20:end,:) = repmat(Nx(end-21,:),20,1);
    %Nx(:,1:20) = repmat(Nx(:,21),1,20);
    %Nx(:,end-20:end) = repmat(Nx(:,end-21),1,20);
    
    
    
    %surface to Point Cloud
    fprintf(1,'Surface to point cloud...\n');
    xp = zeros(1,size(gy2,1)*size(gx2,2));
    yp = zeros(1,size(gy2,1)*size(gx2,2));
    zp = zeros(1,size(gy2,1)*size(gx2,2));
    np = zeros(size(gy2,1)*size(gx2,2),3);
    cp = zeros(size(gy2,1)*size(gx2,2),3);
    
    
    h = waitbar(0,'Surface to point cloud...');
    for i=1:size(gy2,1)
        for j=1:size(gx2,2)
            
            ind = (i-1)*size(gx2,2)+j;
            zt = g2(i,j);
            xt = gx2(i,j);
            yt = gy2(i,j);
            np( ind, : ) = [Nx(i,j) Ny(i,j) Nz(i,j)];
            colval = double(imA(round(yt),round(xt),:)) ./ 255;
            colvalm = double(maskAe(round(yt),round(xt)));
            
            if colvalm == 0
                continue;
            else
                zp( ind ) = zt;
                xp( ind ) = xt;
                yp( ind ) = yt;
            end
            
            
            cp( ind, : ) = [colval];
        end
        waitbar(i/size(gy2,1))
    end
    
    close(h)
    
    
    
    siftvis = 10;
    figure,
    scatter3(xp(1:siftvis:end),yp(1:siftvis:end),zp(1:siftvis:end),2,'b','filled')
    set(gca,'YDir','reverse');
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('Smoothened surface')
    axis equal tight
    rotate3d on
    grid off
    view(10,35)
    set(gcf, 'color', 'white');
    axis off
    pause(2)
    if (savepc)
        saveas(gcf,[dirSaveFig '\' fileA(end-10:end-6) '_leftridge.fig']); 
    end
    
    
    
    
    
    
    xpa = [];
    ypa = [];
    zpa = [];
    colval = [];
    imAgraymed = medfilt2(imAgray,[5 5]);
    %amplification according to surface normals?
    for hh=1:numel(xp)
        
        if (floor(yp(hh)) <= 0 || floor(xp(hh)) <= 0 )
            continue, 
        end
        
        colval1 = imAgraymed(floor(yp(hh)),floor(xp(hh)));
        colval2 = imAgraymed(floor(yp(hh)),ceil(xp(hh)));
        colval3 = imAgraymed(ceil(yp(hh)),floor(xp(hh)));
        colval4 = imAgraymed(ceil(yp(hh)),ceil(xp(hh)));
        
        colval = mean([colval1 colval2 colval3 colval4]);
        
        if (colval > 240)
            continue;
        end
        
        xpa(hh) = xp(hh) + np(hh,1) * double(colval);
        ypa(hh) = yp(hh) + np(hh,2) * double(colval);
        zpa(hh) = zp(hh) + np(hh,3) * double(colval);
        
        %xpa(hh) = xps(hh) + np(hh,1) * 20;
        %ypa(hh) = yps(hh) + np(hh,2) * 20;
        %zpa(hh) = zps(hh) + np(hh,3) * 20;
        
    end
    
    
    
    if(0)
        indp = find(zpa < 150);
        xpa(indp) = [];
        ypa(indp) = [];
        zpa(indp) = [];
        
        indp = find(zp < 150);
        xp(indp) = [];
        yp(indp) = [];
        zp(indp) = [];
    end
    
    
    
    [xpa, ypa, zpa, ip] = func_despike_phasespace3d_3var( xpa, ypa, zpa, 1 );
    
    
    
    siftvis = 1;
    figure,
    scatter3(xpa(1:siftvis:end),ypa(1:siftvis:end),zpa(1:siftvis:end),1,'b','filled')
    set(gca,'YDir','reverse');
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    axis equal tight
    rotate3d on
    grid off
    view(10,35)
    set(gcf, 'color', 'white');
    axis off
    pause(2)
    if (savepc)
        saveas(gcf,[dirSaveFig '\' fileA(end-10:end-6) '_leftridge.fig']);
    end
    
    
    
end %end if




if (savepc)
    C = strsplit(fileA, {'\', '_'});
    str = [C{end-2} '_' C{end-1} '_L'];
    save([dirSaveModel '\' str '_point_cloud.mat'],'XL','YL','ZL');
    %save([dirSaveModel '\' str '_surface.mat'],'gx','gy','g','immap');
    save([dirSaveModel '\' str '_surface.mat'],'gx','gy','g');
    %save([dirSaveModel '\' str '_surfridge.mat'],'xpa','ypa','zpa','cp');
end

if(0)
    fprintf(1,'Writing WRML model...\n');
    writeVRML('fozzi.wrl',[ypa' xpa' zpa'],cp)
end















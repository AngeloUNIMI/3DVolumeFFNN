function [CCCLrf, CCCLmf, CCCL3r, CCCL3m, errorS] = spikefilter2d(CCCLr, CCCLm, maskAe, maskBe, Hp)

%point cloud: CCCLr CCCLm
errorS = 0;


CCCLrf = CCCLr;
CCCLmf = CCCLm;



euclD = NaN .* ones(size(CCCLrf,1),1);
for dd=1:size(CCCLrf,1)
    euclD(dd) = eudistance(CCCLrf(dd,:)',CCCLmf(dd,:)');
end


%Controllo outlier più grossi
if(1)
    nPiall = 2; %numero di controlli outliers % 3
    nstd = 2; %3
    
    for piall=1:nPiall
        
        meuclD = mean(euclD);
        stdeuclD = std(euclD);
        
        
        iz = find(euclD > meuclD + nstd*stdeuclD | euclD < meuclD - nstd*stdeuclD);
        CCCLrf(iz,:) = [];
        CCCLmf(iz,:) = [];
        euclD(iz) = [];
        
    end %end for piall
    
end %end if








if(0)
    %Spike filter
    
    for fff=1:1 %number of iterations
        
        areas = 5; %area for mean and std computation
        thres = 0; %threshold
        thresd = 20; %threshold for distance (helps consider only neighbouring points)
        
        
        [CCCLrf isort] = sortrows(CCCLrf,[1 2]);
        CCCLmf = CCCLmf(isort,:);
        euclD = euclD(isort);
        
        indexrem1 = [];
        %eliminamo spike
        count = numel(euclD);
        ss = 1+floor(areas/2);
        while ss <= count - areas
            
            if  abs(CCCLrf(ss,2) - CCCLrf(ss+floor(areas/2),2)) > thresd
                ss = ss + 1;
                continue;
            end
            
            meanloc = mean([euclD(ss-floor(areas)/2:ss-1)' euclD(ss+1:ss+floor(areas/2))']);
            stdloc = std([euclD(ss-floor(areas/2):ss-1)' euclD(ss+1:ss+floor(areas/2))']) / 2;
            if abs(euclD(ss) - meanloc) > (thres + stdloc)
                %indexrem1 = [indexrem1 ss];
                
                CCCLrf(ss,1) = mean([CCCLrf(ss-areas/2:ss-1,1)' CCCLrf(ss+1:ss+areas/2,1)']);
                CCCLrf(ss,2) = mean([CCCLrf(ss-areas/2:ss-1,2)' CCCLrf(ss+1:ss+areas/2,2)']);
                CCCLmf(ss,1) = mean([CCCLmf(ss-areas/2:ss-1,1)' CCCLmf(ss+1:ss+areas/2,1)']);
                CCCLmf(ss,2) = mean([CCCLmf(ss-areas/2:ss-1,2)' CCCLmf(ss+1:ss+areas/2,2)']);
                euclD(ss) = mean([euclD(ss-areas/2:ss-1)' euclD(ss+1:ss+areas/2)']);
                
            end %end if
            count = numel(euclD);
            ss = ss + 1;
        end %end for
        
        
        
        %CCCLrf(indexrem1,:) = [];
        %CCCLmf(indexrem1,:) = [];
        %euclD(indexrem1) = [];
        
        
        
        [CCCLrf isort] = sortrows(CCCLrf,[2 1]);
        CCCLmf = CCCLmf(isort,:);
        euclD = euclD(isort);
        
        
        
        indexrem2 = [];
        count = numel(euclD);
        ss = 1+floor(areas/2);
        while ss <= count - areas
            
            if  abs(CCCLrf(ss,2) - CCCLrf(ss+floor(areas/2),2)) > thresd
                ss = ss + 1;
                continue;
            end
            
            meanloc = mean([euclD(ss-floor(areas)/2:ss-1)' euclD(ss+1:ss+floor(areas/2))']);
            stdloc = std([euclD(ss-floor(areas/2):ss-1)' euclD(ss+1:ss+floor(areas/2))']) / 2;
            if abs(euclD(ss) - meanloc) > (thres + stdloc)
                %indexrem2 = [indexrem2 ss];
                
                CCCLrf(ss,1) = mean([CCCLrf(ss-areas/2:ss-1,1)' CCCLrf(ss+1:ss+areas/2,1)']);
                CCCLrf(ss,2) = mean([CCCLrf(ss-areas/2:ss-1,2)' CCCLrf(ss+1:ss+areas/2,2)']);
                CCCLmf(ss,1) = mean([CCCLmf(ss-areas/2:ss-1,1)' CCCLmf(ss+1:ss+areas/2,1)']);
                CCCLmf(ss,2) = mean([CCCLmf(ss-areas/2:ss-1,2)' CCCLmf(ss+1:ss+areas/2,2)']);
                euclD(ss) = mean([euclD(ss-areas/2:ss-1)' euclD(ss+1:ss+areas/2)']);
                
            end %end if
            count = numel(euclD);
            ss = ss + 1;
        end %end for
        
        
        
        
        %CCCLrf(indexrem2,:) = [];
        %CCCLmf(indexrem2,:) = [];
        %euclD(indexrem2) = [];
        
        
    end %end for fff
    
    
end


%togliamo i punti in fondo che danno problemi nell'interpolazione di superficie
if(0)
    [CCCLrf isort] = sortrows(CCCLrf,[1 2]);
    CCCLmf = CCCLmf(isort,:);
    euclD = euclD(isort);
    
    CCCLrf(end-50:end,:) = [];
    CCCLmf(end-50:end,:) = [];
    euclD(end-50:end) = [];
end





if(0)
    figure,
    imshow(imAgray), hold on, plot(CCCLrf(:,1),CCCLrf(:,2),'xr','MarkerSize',8,'LineWidth',2);
    title('A')
    figure,
    imshow(imBgray), hold on, plot(CCCLmf(:,1),CCCLmf(:,2),'xr','MarkerSize',8,'LineWidth',2);
    title('B')
    pause(2)
end




if size(CCCLrf,1) <= 1
    fprintf(1, ['occhio al num ' num2str(dd) '_' num2str(gg) '\n']);
    errorS = 1;
    return
end
%punti del piano sotto i punti matchati (filtrati)


CCCL3 = [];
for cc=min(CCCLrf(:,1)):20:max(CCCLrf(:,1))
    for rr=min(CCCLrf(:,2)):20:max(CCCLrf(:,2))
        if (maskAe(floor(rr),floor(cc)) == 1)
            CCCL3 = [CCCL3; [floor(cc) floor(rr)]];
        end
    end
end

CCCL3r = CCCL3;
CCCL3m = [];
for hh=1:size(CCCL3r,1)
    point = CCCL3r(hh,:);
    pointH = [point'; 1];
    pointrH = Hp * pointH;
    pointr = [pointrH(1)/pointrH(3) pointrH(2)/pointrH(3)];
    CCCL3m = [CCCL3m; pointr];
end






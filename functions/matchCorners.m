function [CCCLr, CCCLm] = matchCorners(CCCL, I1r, I1g, I1b, I1gray, I2r, I2g, I2b, I2gray, maskA, maskB, edgeA, edgeB, H3, F, thEp, thCorr)

delta = 15;   %roi

ROI_righe = 5;
ROI_colonne = 70;

clear CCCLr CCCLm
CCCLr = [];
CCCLm = [];


[ib, jb] = find(maskB);
minib = min(ib);
maxib = max(ib);
minjb = min(jb);
maxjb = max(jb);


tic
fprintf(1, '\t\tCorrelation...\n');
fprintf(1, '\t\t\t');
for i_prove = 1:size(CCCL,1)
    
    %first roi estimation using homography matrix
    r = CCCL(i_prove,2);
    c = CCCL(i_prove,1);
    
    
    puntoL_homo = [c r 1];
    puntoR_homo = H3 * puntoL_homo';
    puntoR = [puntoR_homo(1) / puntoR_homo(3) puntoR_homo(2) / puntoR_homo(3)];
    
    deltar = round(puntoR(2) - r);
    deltac = round(puntoR(1) - c);
    
    
    r1 = floor(CCCL(i_prove,2));
    c1 = floor(CCCL(i_prove,1));
    
    % già nelle coordinate della seconda immagine
    ricerca_righe   = [ (r1 + deltar - ROI_righe )    : ( r1 + deltar + ROI_righe ) ];
    ricerca_colonne = [ ( c1 + deltac - ROI_colonne ) : ( c1 + deltac + ROI_colonne) ];
    
    if (r1-delta <= 0 || r+delta > size(I1gray,1) || c1-delta <= 0 || c+delta > size(I1gray,2)	)
        continue;
    else
        %RIFcolor = I1( r1-delta:r+delta, c1-delta:c+delta, :);
        RIFgray = I1gray( r1-delta:r+delta, c1-delta:c+delta);
        RIFr = I1r( r1-delta:r+delta, c1-delta:c+delta);
        RIFg = I1g( r1-delta:r+delta, c1-delta:c+delta);
        RIFb = I1b( r1-delta:r+delta, c1-delta:c+delta);
    end
    
    
    RIFgrayD = im2double(RIFgray);
    if var(RIFgrayD(:))  < 0.0015
        continue;
    end
    
    %
    
    %%%%%%%%%%%%%%%%%%%%
    % correlazione 2D
    %%%%%%%%%%%%%%%%%%%%
    
    massimo_corr = -1e10;
    
    conta = 1;
    dove_r = [];
    dove_c = [];
    RIF_best = [];
    RIF2_best = [];
    
    
    for ir = ricerca_righe
        for ic = ricerca_colonne
            
            conta = conta + 1;
            
            [dd2, lr] = ep_dist([c r],F,[ic ir]);
            
            
            if (ir-delta <= minib || ir+delta > maxib || ic-delta <= minjb || ic+delta > maxjb	...
                    || abs(dd2) > thEp )
                continue;
            else
                
                %edge check
                if (edgeB(ir,ic) == edgeA(r1,c1))
                    %
                else
                    continue,
                end
                
                %RIF2color = I2 ( (ir - delta) : (ir + delta) , (ic - delta) : (ic + delta) , :);
                RIF2gray = I2gray ( (ir - delta) : (ir + delta) , (ic - delta) : (ic + delta) );
                RIF2r = I2r ( (ir - delta) : (ir + delta) , (ic - delta) : (ic + delta) );
                RIF2g = I2g ( (ir - delta) : (ir + delta) , (ic - delta) : (ic + delta) );
                RIF2b = I2b ( (ir - delta) : (ir + delta) , (ic - delta) : (ic + delta) );
            end
            
            OUTgray = prcorr2(RIFgray , RIF2gray );
            OUTr = prcorr2(RIFr , RIF2r );
            OUTg = prcorr2(RIFg , RIF2g );
            OUTb = prcorr2(RIFb , RIF2b );
            
            [OUTMax,imax] = max([OUTgray OUTr OUTg OUTb]);
            %[OUTMax,imax] = max([OUTg]);
            
            
            
            if (OUTMax > massimo_corr && OUTMax > thCorr)
                massimo_corr = OUTMax;
                dove_r = ir;
                dove_c = ic;
                %controllo roi
                if (maskB(ir,ic) == 1)
                    %
                else
                    continue;
                end
                
                %RIF2_best = RIF2gray;
                RIF2_best = RIF2g;
                imaxt = imax;
            end  % ricerca massimo
            
            
        end  % colonne
        
    end % righe
    
    
    %potrebbe non aver trovato una regione compresa nei limiti
    %nella seconda immagine
    if numel(RIF2_best) ~= 0
        
        if numel(CCCLm) > 0
            [res, loc] = ismember([dove_c dove_r],CCCLm,'rows');
        else
            res = 0;
        end %if numel
        
        if (res == 1)
            
            refnorml1 = I1g ( (CCCLr(loc,2) - delta) : (CCCLr(loc,2) + delta) , (CCCLr(loc,1) - delta) : (CCCLr(loc,1) + delta) );
            refnormr1 = I2g ( (CCCLm(loc,2) - delta) : (CCCLm(loc,2) + delta) , (CCCLm(loc,1) - delta) : (CCCLm(loc,1) + delta) );
            
            refnorml2 = I1g ( (CCCL(i_prove,2) - delta) : ( CCCL(i_prove,2) + delta) , ( CCCL(i_prove,1) - delta) : ( CCCL(i_prove,1) + delta) );
            refnormr2 = I2g ( (dove_r - delta) : ( dove_r + delta) , ( dove_c - delta) : ( dove_c + delta) );
            
            corrnorm1 = prcorr2(refnorml1,refnormr1);
            corrnorm2 = prcorr2(refnorml2,refnormr2);
            
            
            if (corrnorm1 >= corrnorm2)
                %
            else
                CCCLr(loc,:) = [CCCL(i_prove,1) CCCL(i_prove,2)];
                CCCLm(loc,:) = [dove_c dove_r];
            end %end if corrnorm
            
        else %else if res
            
            CCCLr = [CCCLr; [CCCL(i_prove,1) CCCL(i_prove,2)]];
            CCCLm = [CCCLm; [dove_c dove_r]];
            
            
        end %end if res
        
        
        
    end %end if numel
    
    
    
    
    %CCCLr = [CCCLr; [CCCL(i_prove,1) CCCL(i_prove,2)]];
    %CCCLm = [CCCLm; [dove_c dove_r]];
    
    if(0)
        subplot(2,3,1),
        imshow(imA,[]), hold on, plot(CCCLr(end,1),CCCLr(end,2),'xr','MarkerSize',8,'LineWidth',2);
        title(['A - Punto: ' num2str(i_prove)])
        subplot(2,3,4),
        imshow(imB,[]), hold on, plot(CCCLm(end,1),CCCLm(end,2),'xr','MarkerSize',8,'LineWidth',2);
        title('B')
        subplot(2,3,2),
        imshow(RIFcolor), hold on
        title('Zoom A')
        subplot(2,3,5),
        imshow(RIF2color_best), hold on
        title(['Zoom B - Massimo Corr: ' num2str(massimo_corr) ' Indice max corr: ' num2str(imaxt)])
        %subplot(2,3,3),
        %imshow(RIFhs), hold on
        %title('Zoom A HS')
        %subplot(2,3,6),
        %imshow(RIF_besths), hold on
        %title(['Zoom B HS - Massimo Corr: ' num2str(OUThs)])
        pause(2)
    end
    
    
    
    if (mod(i_prove, 50) == 0)
        fprintf(1,'%d ', i_prove);
    end
    if (mod(i_prove, 1000) == 0)
        fprintf(1,'\n');
        fprintf(1,'\t\t\t');
    end
    
    
    
    %waitbar(i_prove/size(CCCL,1));
    
end % end for i_prove



%close(h)
fprintf(1,'\n');
%fprintf(1,'\n');

timeT = toc;

fprintf(1,'\t\tTime: %d s\n', timeT);


function CCCL = pointExtract(maskA, edgeA, stepP, nPunti)


%calcolo punti
[il, jl] = find(maskA == 1);
puntiIn = [jl, il];


if(0)
    %puntiIn = shuffle(puntiIn,1);
    puntiIn = sortrows(puntiIn,[1 2]);
    step = round(size(puntiIn,1) / nPunti);
    puntiRanA = puntiIn(1:step:end,:);
    CCCL = puntiRanA;
end %if 0


CCCL = [];


if size(CCCL,1) >= (nPunti - 50)
    pemeth = '\t\tCorner detector';
    fprintf(1, [pemeth '\n']);
else %if size
    
    CCCL = [];
    ii = 1;
    
    for cc=min(jl):stepP:max(jl)
        for rr=min(il):stepP:max(il)
            if (maskA(rr,cc) == 1 && edgeA(rr,cc) == 1)
                %if (maskA(rr,cc) == 1),
                CCCL(ii,:) = [cc rr];
                ii = ii + 1;
            end
        end
    end
    
    
    if (size(CCCL,1) <= nPunti)
        while size(CCCL,1) < (nPunti - 50)
            CCCL = [];
            ii = 1;
            for cc=min(jl):stepP:max(jl)
                for rr=min(il):stepP:max(il)
                    if (maskA(rr,cc) == 1 && edgeA(rr,cc) == 1)
                        %if (maskA(rr,cc) == 1),
                        CCCL(ii,:) = [cc rr];
                        ii = ii + 1;
                    end
                end
            end
            
            if (size(CCCL,1) < (nPunti - 50))
                stepP = stepP - 1;
            end
            
        end %end while
        
    elseif (size(CCCL,1) > nPunti)
        while size(CCCL,1) > (nPunti + 50)
            CCCL = [];
            ii = 1;
            for cc=min(jl):stepP:max(jl)
                for rr=min(il):stepP:max(il)
                    if (maskA(rr,cc) == 1 && edgeA(rr,cc) == 1)
                        %if (maskA(rr,cc) == 1),
                        CCCL(ii,:) = [cc rr];
                        ii = ii + 1;
                    end
                end
            end
            
            if (size(CCCL,1) > (nPunti + 50))
                stepP = stepP + 1;
            end
            
        end %end while
        
    end %end if
    
    pemeth = '\t\tDownsample with edge reference';
    fprintf(1, [pemeth '\n']);
    
end %end else

%whos CCCL

%ulteriore if di controllo
if size(CCCL,1) < 50
    CCCL = [];
    ii = 1;
    stepP = 10;
    for cc=min(jl):stepP:max(jl)
        for rr=min(il):stepP:max(il)
            if (maskA(rr,cc) == 1 && edgeA(rr,cc) == 1)
                %if (maskA(rr,cc) == 1),
                CCCL(ii,:) = [cc rr];
                ii = ii + 1;
            end
        end
    end
end
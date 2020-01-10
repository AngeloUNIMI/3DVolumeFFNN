function [maskA,maskAe] = segOggetti2(imA,imAgray)


tt = medfilt2(imAgray,[5 5]);

t = edge(tt,'sobel',0.015);

t2 = morf(t,'close','diamond',50);
t2 = imfill(t2,'holes');


t3 = morf(t2,'open','diamond',15);

t4 = morf(t3,'close','square',50);

t5 = ~(imAgray > 250);




maskA = t4 .* t5;
maskA(880:end,:) = 0;

maskAe = morf(maskA,'erode','diamond',10); 







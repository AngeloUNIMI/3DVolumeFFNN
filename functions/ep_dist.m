function [dd,l] = ep_dist(puntoL,F,puntoR,l),

%la funzione calcola la linea epipolare l
%dal puntoL e dalla fundamental matrix F (o dalla essential matrix)
%poi calcola la distanza del puntoR dalla linea epipolare l

l = F * [puntoL'; 1];

puntoLh = [puntoL'; 1];
puntoR = puntoR';
puntoRh = [puntoR; 1];

%dd = line_imp_point_dist_2d(l(1),l(2),l(3),puntoRh);

dd = (puntoRh' * F * puntoLh) / sqrt(l(1)^2 + l(2)^2);

%dd = l' * puntoLh;
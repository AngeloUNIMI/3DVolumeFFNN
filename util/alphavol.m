function V = alphavol(X,R,graph)
%ALPHAVOL Volume/area of 3D/2D alpha shape.
%   V = ALPHAVOL(X,R) gives the volume/area V of the basic alpha shape
%   for a 3D/2D point set. X is a coordinate matrix of size Nx3 or Nx2
%   and R is the probe radius. Default is R = Inf.
%
%   The basic alpha shape for R = Inf is the convex hull. This code uses
%   Delaunay triangulation of the point set.
%
%   V = ALPHAVOL(X,R,1) will also produce a plot.
%
%   % 2D Example - C shape
%   t = linspace(0.6,5.7,500)';
%   X = 2*[cos(t),sin(t)] + rand(500,2);
%   subplot(221), alphavol(X,inf,1);
%   subplot(222), alphavol(X,1,1);
%   subplot(223), alphavol(X,0.5,1);
%   subplot(224), alphavol(X,0.2,1);
%
%   % 3D Example - Ring
%   [x,y,z] = sphere;
%   ii = abs(z) < 0.4;
%   X = [x(ii),y(ii),z(ii)];
%   X = [X; 0.8*X];
%   subplot(211), alphavol(X,inf,1);
%   subplot(212), alphavol(X,0.5,1);
%
%   See also delaunayn, TriRep, circumcenters

%   Author: Jonas Lundgren <splinefit@gmail.com> 2010

%   2010-09-27  First version of ALPHAVOL.
%   2010-10-05  DelaunayTri replaced by delaunayn. 3D plots added.

if nargin < 2 || isempty(R), R = inf; end
if nargin < 3, graph = 0; end

% Dimension
dim = size(X,2);
if dim < 2 || dim > 3
    error('alphavol:dimension','X must have 2 or 3 columns.')
end

% Unique points
X = unique(X,'rows');

if R > 0
    % Delaunay triangulation
    %T = delaunayn(X);
    T = delaunayn(X,{'Qt','Qbb','Qc','Qz'});
    % Limit circumradius of primitives
    if R < inf
        dt = TriRep(T,X);
        [junk,rcc] = circumcenters(dt); %#ok
        T = T(rcc < R,:);
    end
else
    % Empty triangulation
    T = zeros(0,dim+1);
end

% Volume/Area of primitives
V = volumes(T,X);
V = sum(V);

% Plot alpha shape
if graph
    if dim == 3
        alphaplot3(T,X,R,V)
    else
        alphaplot2(T,X,R,V)
    end
end


%--------------------------------------------------------------------------
function V = volumes(T,X)
% Volume/area of tetrahedra/triangles

% Empty triangulation
if isempty(T)
    V = [];
    return
end

% Local coordinates
A = X(T(:,1),:);
B = X(T(:,2),:) - A;
C = X(T(:,3),:) - A;
    
if size(X,2) == 3
    % 3D Volume
    D = X(T(:,4),:) - A;
    BxC = cross(B,C,2);
    V = dot(BxC,D,2);
    V = abs(V)/6;
else
    % 2D Area
    V = B(:,1).*C(:,2) - B(:,2).*C(:,1);
    V = abs(V)/2;
end


%--------------------------------------------------------------------------
function alphaplot2(T,X,radius,area)
% Plot 2D alpha shape

% Remove inner edges
E = [T(:,2:3); T(:,[1 3]); T(:,1:2)];
E = sort(E,2);
E = sortrows(E);
ii = find(~any(diff(E),2));
E([ii;ii+1],:) = [];

% Coordinates
x = X(:,1);
y = X(:,2);
xb = x(E)';
yb = y(E)';

% Plot point set and boundary edges
plot(x,y,'k.',xb,yb,'b',xb,yb,'r.')

% Title
str = sprintf('Radius = %g,   Area = %g',radius,area);
title(str,'fontsize',12)


%--------------------------------------------------------------------------
function alphaplot3(T,X,radius,volume)
% Plot 3D alpha shape

% Remove inner faces
F = [T(:,2:4); T(:,[1 3 4]); T(:,[1 2 4]); T(:,1:3)];
F = sort(F,2);
F = sortrows(F);
ii = find(~any(diff(F),2));
F([ii;ii+1],:) = [];

% Coordinates
x = X(:,1);
y = X(:,2);
z = X(:,3);

% Plot boundary faces
trisurf(F,x,y,z,'FaceColor','yellow','FaceAlpha',1);
% hold on
% plot3(x,y,z,'k.')
% hold off
axis equal

% Title
str = sprintf('Radius = %g,   Volume = %g',radius,volume);
title(str,'fontsize',12)


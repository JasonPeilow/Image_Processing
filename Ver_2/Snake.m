%---------Snake Start-------

%---------Ex 1-------
n = 200; 
[Y,X] = meshgrid(1:n,1:n);

%---Solution---

do_fast = 1;
% radius
r = n/3;
% center
c = n  - 10 - [r r];
% shape
phi2 = max( abs(X-c(1)), abs(Y-c(2)) ) - r;

%---------Ex 2-------
%---Insert code start---
phi0 = min(phi1,phi2);
clf;
subplot(1,2,1);
plot_levelset(min(phi1,phi2));
title('Union');
subplot(1,2,2);
plot_levelset(max(phi1,phi2));
title('Intersection');
%---Insert code end---

clf;
subplot(1,2,1);
plot_levelset(phi1);
subplot(1,2,2);
plot_levelset(phi2);

phi1 = sqrt( (X-c(1)).^2 + (Y-c(2)).^2 ) - r;


%---------Ex 3-------
%---Insert code start---
if do_fast
phi = phi0; % initialization
clf;
k = 0;
for i=1:niter
    g0 = grad(phi,options);
    d = max(eps, sqrt(sum(g0.^2,3)) );
    g = g0 ./ repmat( d, [1 1 2] );
    K = d .* div( g,options );
    phi = phi + tau*K;
    % redistance the function from time to time
    if mod(i,30)==0
        % phi = perform_redistancing(phi);
    end
    if mod(i, floor(niter/4))==0
        k = k+1;
        subplot(2,2,k);
        plot_levelset(phi);
    end
end
end
%---Insert code end---

%---------Ex 4-------
[Y,X] = meshgrid(1:n,1:n);
r = n/3;
c = [n n]/2;
phi0 = max( abs(X-c(1)), abs(Y-c(2)) ) - r;

%---------Ex 5-------
gD = grad(phi,options);
% normalized gradient
d = max(eps, sqrt(sum(gD.^2,3)) );
g = gD ./ repmat( d, [1 1 2] );
% gradient
G = - W .* d .* div( g,options ) - sum(gW.*gD,3);

%---------Ex 6-------
if do_fast
phi = phi0;
k = 0;
gW = grad(W,options);
for i=1:niter
    gD = grad(phi,options);
    d = max(eps, sqrt(sum(gD.^2,3)) );
    g = gD ./ repmat( d, [1 1 2] );
    G = W .* d .* div( g,options ) + sum(gW.*gD,3);
    phi = phi + tau*G;
    if mod(i,30)==0
        phi = perform_redistancing(phi);
    end
    if mod(i, floor(niter/4))==0
        k = k+1;
        subplot(2,2,k);
        plot_levelset(phi,0,f0);
    end
end
end

%---------Ex 7-------
[Y,X] = meshgrid(1:n,1:n);
k = 4; %number of circles
r = .3*n/k;
phi0 = zeros(n,n)+Inf;
for i=1:k
    for j=1:k
        c = ([i j]-1)*(n/k)+(n/k)*.5;
        phi0 = min( phi0, sqrt( (X-c(1)).^2 + (Y-c(2)).^2 ) - r );
    end
end
clf;
subplot(1,2,1);
plot_levelset(phi0);
subplot(1,2,2);
plot_levelset(phi0,0,f0);

%---------Ex 8-------
% \(phi\).
gD = grad(phi,options);
d = max(eps, sqrt(sum(gD.^2,3)) );
g = gD ./ repmat( d, [1 1 2] );
% gradient
G = d .* div( g,options ) - lambda*(f0-c1).^2 + lambda*(f0-c2).^2;

%---------Ex 9-------
if do_fast
phi = phi0; 
k = 0;
clf;
for i=1:niter
    gD = grad(phi,options);
    d = max(eps, sqrt(sum(gD.^2,3)) );
    g = gD ./ repmat( d, [1 1 2] );
    G = d .* div( g,options ) - lambda*(f0-c1).^2 + lambda*(f0-c2).^2;
    phi = phi + tau*G;
    if mod(i,30)==0
        phi = perform_redistancing(phi);
    end
    if mod(i, floor(niter/4))==0
        k = k+1;
        subplot(2,2,k);
        plot_levelset(phi,0,f0);
    end
end
end

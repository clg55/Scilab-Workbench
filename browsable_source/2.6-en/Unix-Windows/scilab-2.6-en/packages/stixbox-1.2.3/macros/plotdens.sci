function [h,f,xx]=plotdens(x,h,positive,akernel)
f=[];xx=[];
[nargout,nargin] = argn(0)
//PLOTDENS Draw a nonparametric density estimate.
// 
//         plotdens(X)
// 
//	  A density estimate is plotted using a aakernel density
//	  estimate. A longer form plotdens(X,h,P,K) may be used
//	  where h is the akernel bandwidth, P is 1 if the density
//	  is known to be 0 for negative X, and K is
// 
//	  1 Gaussian (the default)
//	  2 Epanechnikov
//	  3 Biweight
//	  4 Triangular
// 
//	  Below the density estimate a jittered plot of the obser-
//	  vations is shown.
// 
//	  See also HISTO.
 
x = x(:);
n = mtlb_length(x);
if nargin<4 then
  akernel = 1;
end
if nargin<3 then
  positive = 0;
end
if nargin<2 then
  h = [];
end
if h==[] then
  h = 1.0600000000000001*std(x)*(n^(-1/5));
  // Silverman page 45
end
if positive&or(x<0) then
  error('There is a negative element in X');
end
 
mn1 = min(x);
mx1 = max(x);
mn = mn1-(mx1-mn1)/3;
mx = mx1+(mx1-mn1)/3;
gridsize = 256;
xx = linspace(mn,mx,gridsize)';
d = xx(2)-xx(1);
%v=size(xx)
xh = zeros(%v(1),%v(2));
xa = (x-mn)/(mx-mn)*gridsize;
for i = 1:n
  il = floor(xa(i));
  a = xa(i)-il;
  xh(il+[1,2]) = xh(il+[1,2])+[1-a,a]';
end
 
// --- Compute -------------------------------------------------
 
xk = ((-gridsize:gridsize-1)')*d;
if akernel==1 then
  K = exp(-0.5*(xk/h).^2);
elseif akernel==2 then
  K = max(0,1-(xk/h).^2/5);
elseif akernel==3 then
  c = sqrt(1/7);
  K = (1-(xk/h)*c.^2).^2 .* (bool2s((1-abs(xk/h*c))>0));
elseif akernel==4 then
  c = sqrt(1/6);
  K = max(0,1-abs(xk/h*c));
end
K = K/(mtlb_sum(K)*d*n);
%v=size(xh)
f = fft(fft(fftshift(K),-1) .* fft([xh;zeros(%v(1),%v(2))],-1),1);
// mtlb_e(f,1:gridsize) may be replaced by f(1:gridsize) if f is a vector.
f = real(mtlb_e(f,1:gridsize));
 
if positive then
  m = sum(bool2s(xx<0));
  // mtlb_e(f,bool2s(m)+(1:m)) may be replaced by f(bool2s(m)+(1:m)) if f is a vector.
  // mtlb_e(f,m:-1:1) may be replaced by f(m:-1:1) if f is a vector.
  f(bool2s(m)+(1:m)) = mtlb_e(f,bool2s(m)+(1:m))+mtlb_e(f,m:-1:1);
  // mtlb_e(f,1:m) may be replaced by f(1:m) if f is a vector.
  %v1=size(mtlb_e(f,1:m))
  f(1:m) = zeros(%v1(1),%v1(2));
  xx(bool2s(m)+[0,1]) = [0,0];
end
 
// --- Plot it -------------------------------------------------
 
//mtlb_plot(xx,f);
xmin=floor(min(xx));
xmax=ceil(max(xx));
ymin=floor(min(f));
ymax=ceil(max(f));

plot2d1("gnn",xx,f,[5],"051"," ",[xmin,ymin-0.5,xmax,ymax]); 

//if ~ishold then
//  hold('on');
  d = ymax/100;
  %v1=size(x)
  yyy=(-rand(%v1(1),%v1(2),'u')*6-1)*d;
  xset("pattern",32);
  plot2d1("gnn",x,yyy,[0],"051"," ",[xmin,ymin-0.5,xmax,ymax]); 
  plot2d([mn,mx],[0,0],[1],"051"," ",[xmin,ymin-0.5,xmax,ymax]); 
//  axis([mn,mx,-0.2*mtlb_max(f),mtlb_max(f)*1.2]);
//  hold('off');
//end


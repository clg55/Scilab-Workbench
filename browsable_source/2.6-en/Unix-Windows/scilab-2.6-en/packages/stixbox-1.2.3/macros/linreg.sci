function [b,cibeta,s,residuals]=linreg(y,x,confidence,sym,pmax)
b=[];cibeta=[];s=[];residuals=[];
[nargout,nargin] = argn(0)
// Linear or polynomial regression
//
//	  linreg(y,x)
//         [b, Ib, e, s, Is] = linreg(y,x,C,sym,pmax)
//
//         The output  b  is the point estimate of the parametars 
//         in the model  y = b(1)*x + b(2) + error.
//         The columns of  Ib  are the corresponding confidence 
//         intervals. The residuals are in  e. The standard deviation 
//	  of the residuals is  s.
//
//         A pointwise confidence band for the expected y-value is
//         plotted, as well as a dashed line which indicates the
//         prediction interval given x. The input  C  is the confidence
//	  which is 0.95 by default. C = []  gives no plotting
//         of confidence band or prediction band.
//
//	  Input sym is plotting symbol, with 'o' as default. For 
//	  polynomial regression give input  pmax  a desired value,  
//	  the model is then  y = [x^pmax, ... x^2, x, 1] * b' + error.

//       Anders Holtsberg, 27-07-95
//       Copyright (c) Anders Holtsberg

//	Revision 01-10-98 Mathematique Universite de Paris-Sud
 
if nargin<3 then
  confidence = 0.95;
end
if nargin<4 then
  sym = [];
end
if sym==[] then
  sym = 9;
end
if nargin<5 then
  pmax = 1;
end
 
y = y(:);
x = x(:);
[b,S] = polyfit(x,y,pmax);
df = S(pmax+2,1);
s = S(pmax+3,1)/sqrt(df);
C = S(1:pmax+1,:);
mn = 1.1*min(x)-0.1*max(x);
mx = 1.1*max(x)-0.1*min(x);
xx = linspace(mn,mx,20)';
// The following factoring idea (but not code!) is stolen from polyval
V = xx(:,ones(1,pmax+1));
V = V.^(ones(max(size(xx)),1)*(pmax:-1:0));
E = V/C;
yy = polyval(b($:-1:1),xx);
t = qt(1-(1-confidence)/2,df);
d = mtlb_sum((E .* E)')';
dd = t*s*sqrt(d);
ym = yy-dd;
yp = yy+dd;
dd1 = t*s*sqrt(1+d);
ym1 = yy-dd1;
yp1 = yy+dd1;

//hold('off');
//plot2d(x,y,-sym)

plot2d1("gnn",x,y,[-sym],"051"," ",[mn,floor(min(y)),mx,ceil(max(y))]);
//hold('on');
plot2d(xx,yy,[1],"000");
//mtlb_plot(xx,yy);
if max(size(ym))>0 then
 plot2d(xx,ym,[4],"000");  
 plot2d(xx,yp,[4],"000");  
 plot2d(xx,ym1,[6],"000");  
 plot2d(xx,yp1,[6],"000");  
//  mtlb_plot(xx,ym);
//  mtlb_plot(xx,yp);
//  mtlb_plot(xx,ym1,'--');
//  mtlb_plot(xx,yp1,'--');
end
 
d = sqrt(diag(inv(C'*C)));
cibeta = [b'-t*d,b'+t*d]';
residuals = y-polyval(b,x);
 

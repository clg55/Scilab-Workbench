function []=stixdemo()
//STIXDEMO Demonstrate various stixbox routines.
 
//       Anders Holtsberg, 25-11-94
//       Copyright (c) Anders Holtsberg
//       and J. Coursol Paris Sud University
//       Scilab version : Scilab Group
disp('When paused with -->halt() enter return key to continue')
disp('When halted without --> mouse click on the plot')

xbasc();

//	Let us start with some data, for example a small correlated
//	two dimensional sample with some weird underlying distribution.
 
n = 20;
Y = rchisq(n,3);
X = Y+3*rand(n,1,'u');

xset("thickness",2); xset("font",4,2);
halt()

//	==================== IDENTIFY ====================
//	The first thing to do is to plot the data.
//	Now, identify the numbers of some interesting observations
//	by clicking with the left mouse button on them. Quit by
//	clicking with the middle mouse button.
  
identify(X,Y)
 
halt()

//	========================================================
//	      THE JACKKNIFE AND THE BOOTSTRAP ESTIMATE
//	                OF STANDARD DEVIATION
//	========================================================
// 
//	Let's compute the mean of X and its estimated standard
//	deviation.

mtlb_mean(X)
std(X)/sqrt(n)
stdjack(X,'mean')
stdboot(X,'mean')
halt()
//	The same thing for the median.
 
mtlb_median(X);
stdjack(X,'median')
stdboot(X,'median')
stdboot(X,'median')
halt()
//	A spectacular example is to give confidence intervals for the
//	quantile of a distribution. There are at least 3 ways to define
//	an empirical quantile estimator. Look at the plot to see them
//	applied to X.
 
%v = X;
if min(size(%v))==1 then %v=sort(%v);
else %v=sort(%v,'r'); end;
XX = %v($:-1:1,:);
%v$2 = ((0:n)')/n;
%v$2 = [XX(1);XX];
%v$2 = %v$2';
%v$2 = %v$2';
xmin=floor(min(%v$2));
xmax=ceil(max(%v$2));
xbasc();
plot2d2('gnn',%v$2,%v$2/xmax,[3],"051"," ",[xmin,xmin,xmax,1]);
plot2d1("gnn",XX,(((1:n)')-0.5)/n,[9],"051"," ",[xmin,xmin,xmax,1]);
plot2d1("gnn",XX,((1:n)')/(n+1),[5],"051"," ",[xmin,xmin,xmax,1]);
xset("thickness",0);xgrid(1);xset("thickness",2);

halt()
//	Let's use the method indicated by the green line and compute
//	some quantiles for X along with its standard deviation. The
//	bootstrap is used for computing a standard deviation estimate
//	which we use for plotting a 90 percent confidence interval through
//	a normal approximation.

xbasc()
p = (0.1:0.1:0.9)';
qx = quantile(X,p,1);
sqx = stdboot(X,'quantile',200,p);
plot2d([p,p,p],[qx-1.6399999999999999*sqx,qx,qx+1.6399999999999999*sqx]);
xset("thickness",0);xgrid(1);xset("thickness",2);
halt()
//	However, there are fancier methods than normal approximations ...
// 
//	Let us redo the quantile example with full fledged bootstrap
//	confidence intervals based on 1000 simulations.

Imb = ciboot(X,'quantile',[],0.9,2000,p);
xbasc();
plot2d([p,p,p],Imb);
xgrid()

//	Great fun, isn't it?

//	A bootstrap confidence interval is based on the bootstrap
//	distribution for some quantity. One might have a look at the
//	distribution for it. The confidence interval for the standard
//	deviation of X will serve as an example.
 
[Imb,T] = ciboot(X,'std',[],0.9,1000);
Imb = Imb

halt()

//	A histogram of the bootstrapped distribution of T (=std(X))
//	and a kernel density estimate looks like this.

xbasc() 
xsetech([0/1,0/2,1/1,1/2]);
histo(T);
xsetech([0/1,1/2,1/1,1/2]);
plotdens(T);

//	One might plot the histogram on top of the kernel density
//	estimate also.
halt()
histo(T,[],0,1,1);

halt()

xset('default');
//	================= LINEAR REGRESSION ======================
// 
//	A standard linear regression looks like this.

X = rand(30,1,'n');
Y = 2+3*X+rand(30,1,'n');
xbasc();
xset("thickness",2); 
xset("font",4,2)
linreg(Y,X);
xset("thickness",0);
xset("use color",0);xgrid(6);xset("use color",1);
xset("thickness",2);

halt()

// Strike any key to continue.
//	You may identify observations here too.
//	Click with the mouse. End with middle button.
 
identify(X,Y,1)

//	==========================================================
//	DATA MATERIALS
//
//	There are some data materials included.
//	==========================================================

 
x = getdata();
if size(x,2) < 2 
	xbasc();
	plot2d1("enn",[],x(:,1),-9); 
else
	plot2d(x(:,1),x(:,2),-9); 
end 
halt()

xset('default');
xbasc();
xset("background",33);
xset("foreground",32);
xbasc();
xset("pattern",32);

if size(x,2) < 2 
	xbasc();
	plot2d1("enn",[],x(:,1),-9); 
else
	plot2d(x(:,1),x(:,2),-9); 
end 

halt()

xset('default');
 
xbasc();

m = 12;
x = [rand(m,1,'n');rand(m,1,'n')+2;rand(m,1,'n')+4];
y = [rand(m,1,'n');rand(m,1,'n')+4;rand(m,1,'n')+3];
s = ones(m,1)*[1,2,3];
s = s(:);
plotsym(x,y,s,'stc','k');

halt()


//	================= FANCY PLOTTING ====================
// 
//	2. Plot with different colors
 
z = (1:3*m)';
 
plotsym(x,y,s,'stc',z);
 
xset('colormap',hotcolormap(32));
 
halt()

//	================= FANCY PLOTTING ====================
// 
//	3. Plot with different sizes instead
 
z = z/max(z)*5;
 
plotsym(x,y,s,'stc','k',z);
 
halt()

//	================= FANCY PLOTTING ====================
// 
//	4. Random place, form, color, and size. A really cool plot ...
 
m = 100;
x = rand(m,1,'n');
y = rand(m,1,'n');
form = ceil(rand(m,1,'u')*7);
// note: 7 forms available
color = ceil(32*rand(m,1,'u'));
ssize = rand(m,1,'u')*4+1;
 
plotsym(x,y,form,color,ssize);
halt() 
%v$1=(0:31)'/31;
xset('colormap',[%v$1,1-%v$1,ones(%v$1)]);
plotsym(x,y,form,color,ssize);
 
halt()
xset('default');
disp('================= BYE ====================');
// 
disp('Thanks for your attention. Good bye.');

 


function [d,p]=kstwo(x,y)
d=[];p=[];
//KSTWO            Kolmogorov-Smirnov statistic from two samples
// 
//            [d,p] = KSTWO(x,y)
//          Input   x,y samples (column vectors)
// 
//          Output  d   Kolmogorov-Smirnov statistic d
//                  p   significance level p for the null hypothesis
//                      that the data sets x and y are drawn from the
//                      same distribution.
 
// Adapted from Press, Teukolsky, Vetterling
// and Flannery, Numerical Recipes in Fortran p619.
// Uses PROBKS
 
// Version 1.0 RHS 8/11/93
//	Revision 05-05-00 Mathematique Universite de Paris-Sud
 
%v = x
if min(size(%v))==1 then %v=sort(%v),else %v=sort(%v,'r'),end
x = %v($:-1:1,:);
%v = y
if min(size(%v))==1 then %v=sort(%v),else %v=sort(%v,'r'),end
y = %v($:-1:1,:);
// sort in ascending order
 
dx = max(size(x));
dy = max(size(y));
// samples lengths
 
kx = 1;
ky = 1;
fnx = 0;
fny = 0;
count = 1;
// initialise variables
while (kx<=dx)&(ky<=dy) then
  // generate cumulative distribution
  ddx = x(kx);
  ddy = y(ky);
  // functions
  if ddx<=ddy then
    fnx = kx/dx;
    kx = kx+1;
  end
  if ddy<=ddx then
    fny = ky/dy;
    ky = ky+1;
  end
  dt(1,count) = abs(fnx-fny);
  // difference between functions
  count = count+1;
end
 
d = mtlb_max(dt);
// maximum of difference
N = sqrt(dx*dy/(dx+dy));
//p=probks((N+0.12+0.11/N)*d);		% calculate probability
p = 1-pks((N+0.12+0.11/N)*d);
// calculate probability

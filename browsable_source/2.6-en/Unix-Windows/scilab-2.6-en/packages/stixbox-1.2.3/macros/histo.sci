function [h,edge]=histo(x,N,odd,scale,sym)
[nargout,nargin] = argn(0)
//HISTO    plot a  histogram
//  
//         [h,edge]=histo(X)
//         [h,edge]=histo(X,M,odd,scale,S) : 
//             
//
// Input:    X	   datas,
//	    M 	   approximate number of bins,
//           odd	   should be 0 or 1 for placement of bins. Least significant 
//         	   digit of bin width will always be 1, 2 or 5. 
//	    scale  should be one for scaling in order to have the area 1 under
//         	   the histogram instead of area n. 
//	    S 	   string which specifies the plot linestyle
// Output:   egde   edges of the classes of the histogram
//           h      h(i) is the number of values in X that belong to
//                  [edge(i), edge(i+1)[ 

//       Anders Holtsberg, 14-12-94
//       Copyright (c) Anders Holtsberg

//       Revision 04-05-2000 Mathematique Universite de Paris-Sud

if nargin < 2 then  N = [];end
if nargin < 3 then  odd = [];end
if nargin < 4 then  scale = [];end
if nargin < 5 then  sym='b'; end

if N==[] then
  N = ceil(4*sqrt(sqrt(mtlb_length(x))));
end
if odd==[] then
  odd = 0;
end
if scale==[] then
  scale = 0;
end
 
mn = mtlb_min(x);
mx = mtlb_max(x);
d = (mx-mn)/N*2;
e = floor(log(d)/log(10));
m = floor(d/(10^e));
if m>5 then
  m = 5;
elseif m>2 then
  m = 2;
end
d = m*(10^e);
mn = (floor(mn/d)-1)*d-odd*d/2;
mx = (ceil(mx/d)+1)*d+odd*d/2;
limits = mn:d:mx;
 
f = zeros(1,mtlb_length(limits)-1);
for i = 1:mtlb_length(limits)-1
  f(i) = mtlb_sum(bool2s((x>=limits(i))&(x<limits(i+1))));
end
 
xx = [limits;limits;limits];
xx = xx(:);
xx = xx(2:mtlb_length(xx)-1);
yy = [f*0;f;f];
yy = [yy(:);0];
if scale then
  yy = yy/mtlb_length(x)/d;
end
// here we need sym -> scilab style 
if nargin > 4 then
   plot2d(xx,yy,1)
else
   plot2d(xx,yy);
end
if nargout>0 
   h=f;
   edge=limits;
end

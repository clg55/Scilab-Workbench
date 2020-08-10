function []=qqplot(x,y,ps)
[nargout,nargin] = argn(0)
//QQPLOT   Plot empirical quantile vs empirical quantile
// 
//         qqplot(x,y,ps)
// 
//         If two distributions are the same (or possibly linearly
//	  transformed) the points should form an approximately straight
//	  line. Data is x and y. Third argument ps is an optional plot
//	  symbol.
// 
//         See also QQNORM
 
if nargin<3 then
  ps = '*';
end
%v = x
if min(size(%v))==1 then %v=sort(%v),else %v=sort(%v,'r'),end
x = %v($:-1:1,:);
%v = y
if min(size(%v))==1 then %v=sort(%v),else %v=sort(%v,'r'),end
y = %v($:-1:1,:);
mtlb_plot(x,y,ps);
xtitle(' ','Data X',' ');
xtitle(' ',' ','Data Y');

function [f]=dnorm(x,m,s)
// The normal density function 
//         y = dnorm(x,m,s)
//	Input	x	real vector or matrix
//		m	mean (default value is 0)
//		s 	standard deviation (default value is 1)
//
//	Output  y  	normal density function with mean m and standard 
//			deviation s, at the values of x :
//			y=exp(-0.5*((x-m)./s)^2)./sqrt(2pi*s)
//       Anders Holtsberg, 18-11-93
//       Copyright (c) Anders Holtsberg
// last update: janv 2002 (jpc)
//
[nargout,nargin] = argn(0)
if nargin<3 then  s = ones(x);end
if nargin<2 then  m = zeros(x);end
if length(m)==1 then m=m*ones(x);end 
if length(s)==1 then s=s*ones(x);end 
if size(x)<>size(m) then 
  error('dnorm: all arguments must have same size');
end 
if size(x)<>size(s) then 
  error('dnorm: all arguments must have same size');
end 
f=0*ones(s);
z=find(s<0);
if z<>[] then 
   warning('negative standard deviation')
   f(z)= %nan;
end
z=find(s>=0);
if z<>[]
   f(z) = exp(-0.5*((x(z)-m(z))./s(z)).^2)./(sqrt(2*%pi*s(z)));
end



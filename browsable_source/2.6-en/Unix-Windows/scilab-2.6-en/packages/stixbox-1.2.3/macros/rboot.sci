function [z]=rboot(x,B)
z=[];
[nargout,nargin] = argn(0)
//RBOOT    Simulate a bootstrap resample from a sample.
// 
//	  Z = rboot(X)
// 
//	  Give a resample of the same size as X, which is assumed
//	  to have one independent realisation in every row.
//	  RESAMPLE(X,B) gives B columns of resamples. This form works
//	  only for X one-dimensional, ie X column vector.
 
//       Anders Holtsberg, 14-12-94
//       Copyright (c) Anders Holtsberg
 
if min(size(x))==1 then
  x = x(:);
end
 
if (nargin>1)&(size(x,2)>1) then
  if B>1 then
    error('X multidimensional and B > 2');
  end
elseif nargin<2 then
  B = 1;
end
 
n = size(x,1);
nn = n*B;
I = ceil(n*rand(nn,1,'u'));
if B>1 then
  z = zeros(n,B);
  z(:) = x(I);
else
  z = x(I,:);
end

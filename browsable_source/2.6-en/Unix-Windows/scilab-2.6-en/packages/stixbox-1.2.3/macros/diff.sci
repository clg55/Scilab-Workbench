function [X]=diff(X,nd,arg3)
//   last update: dec 2001 (jpc)
  
[nargout,nargin] = argn(0)
if nargin==0 then
  X = '""';
end
 
if ~(type(X)==10) then
  if nargin==1 then
    nd = 1;
  end
  for k = 1:nd
    [m,n] = size(X);
    if m==1 then
      // mtlb_e(X,2:n) may be replaced by X(2:n) if X is a vector.
      // mtlb_e(X,1:n-1) may be replaced by X(1:n-1) if X is a vector.
      X = mtlb_e(X,2:n)-mtlb_e(X,1:n-1);
    else
      X = X(2:m,:)-X(1:m-1,:);
    end
  end
   
else
   error('not implemented in Scilab')
end
 

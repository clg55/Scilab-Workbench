function [xy]=cov(x,y)
xy=[];
[nargout,nargin] = argn(0)
 
[m,n] = size(x);
if nargin>1 then
  [my,ny] = size(y);
  if m~=my|n~=ny then
    error('X and Y must be the same size.');
  end
  x = [x(:),y(:)];
elseif min(size(x))==1 then
  x = x(:);
end
[m,n] = size(x);
x = x-ones(m,1)*sum(x,'r')/m;
if m==1 then
  xy = 0;
else
  xy = x'*x/(m-1);
end
 

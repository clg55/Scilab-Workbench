function [y]=beta(z,w,v)
y=[];
[nargout,nargin] = argn(0)
if nargin==2 then
  y = exp(gammaln(z)+gammaln(w)-gammaln(z+w));
elseif nargin==3 then
  y = betainc(z,w,v);
end

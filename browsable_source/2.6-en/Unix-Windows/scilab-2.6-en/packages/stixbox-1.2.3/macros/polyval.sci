function [y,delta]=polyval(p,x,S)
y=[];delta=[];
[nargout,nargin] = argn(0)
 
[m,n] = size(x);
nc = max(size(p));
 
if (m+n)==2 then
  // Make it scream for scalar x.  Polynomial evaluation can be
  // implemented as a recursive digital filter.
  y = mtlb_filter(1,[1,-x],p);
  y = y(nc);
  if nargin<3 then
    return
     
  end
end
 
// Do general case where X is an array
y = zeros(m,n);
for i = 1:nc
  y = x .* y+p(i);
end
 
if (nargin>2)&(nargout>1) then
  x = x(:);
  [ms,ns] = size(S);
  if ms~=(ns+2)|nc~=ns then
    error('S matrix must be n+2-by-n where n = length(p)');
  end
  R = S(1:nc,1:nc);
  df = S(nc+1,1);
  normr = S(nc+2,1);
   
  // Construct Vandermonde matrix.
  V(:,nc) = ones(mtlb_length(x),1);
  for j = nc-1:-1:1
    V(:,j) = x .* V(:,j+1);
  end
  E = V/R;
  if nc==1 then
    e = sqrt(1+E .* E);
  else
    e = sqrt(1+mtlb_sum(E .* E')');
  end
  if df==0 then
    disp('Warning: zero degrees of freedom implies infinite error bounds.');
    delta = %inf*e;
  else
    delta = normr/sqrt(df)*e;
  end
  delta = matrix(delta,m,n);
end
 

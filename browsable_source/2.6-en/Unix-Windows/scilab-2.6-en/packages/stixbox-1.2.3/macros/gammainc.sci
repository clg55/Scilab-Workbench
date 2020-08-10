function [b]=gammainc(x,a)
b=[];
 
if (prod(size(x))==1)&(prod(size(a))~=1) then
  [m,n] = size(a);
  x = x(ones(m,1),ones(n,1));
end
 
b = x;
lngama = gammaln(a);
 
//  mtlb_find(x==0) may be replaced by
//  find(x==0)' if x==0 is not a row vector
k = mtlb_find(x==0);
if or(k) then
  b(k) = 0*k;
end
 
//  mtlb_find((x~=0)&(x<(a+1))) may be replaced by
//  find((x~=0)&(x<(a+1)))' if (x~=0)&(x<(a+1)) is not a row vector
k = mtlb_find((x~=0)&(x<(a+1)));
if or(k) then
  if prod(size(a))==1 then
    // Series expansion for x < a+1
    ap = a;
    %v2=size(k)
    %sum = ones(%v2(1),%v2(2))/a;
    del = %sum;
    while norm(del,'inf')>=10*%eps*norm(%sum,'inf') then
      ap = ap+1;
      // mtlb_e(x,k) may be replaced by x(k) if x is a vector.
      del = mtlb_e(x,k) .* del/ap;
      %sum = %sum+del;
    end
    // mtlb_e(x,k) may be replaced by x(k) if x is a vector.
    // mtlb_e(x,k) may be replaced by x(k) if x is a vector.
    b(k) = %sum .* exp(-mtlb_e(x,k)+a*log(mtlb_e(x,k))-lngama);
  else
    // Series expansion for x < a+1
    ap = a;
    %v2=size(k)
    // mtlb_e(a,k) may be replaced by a(k) if a is a vector.
    %sum = ones(%v2(1),%v2(2)) ./ mtlb_e(a,k);
    del = %sum;
    while norm(del,'inf')>=10*%eps*norm(%sum,'inf') then
      ap = ap+1;
      // mtlb_e(x,k) may be replaced by x(k) if x is a vector.
      // mtlb_e(ap,k) may be replaced by ap(k) if ap is a vector.
      del = mtlb_e(x,k) .* del ./ mtlb_e(ap,k);
      %sum = %sum+del;
    end
    // mtlb_e(x,k) may be replaced by x(k) if x is a vector.
    // mtlb_e(a,k) may be replaced by a(k) if a is a vector.
    // mtlb_e(x,k) may be replaced by x(k) if x is a vector.
    // mtlb_e(a,k) may be replaced by a(k) if a is a vector.
    b(k) = %sum .* exp(-mtlb_e(x,k)+mtlb_e(a,k) .* log(mtlb_e(x,k))-gammaln(mtlb_e(a,k)));
  end
end
 
//  mtlb_find(x>=(a+1)) may be replaced by
//  find(x>=(a+1))' if x>=(a+1) is not a row vector
k = mtlb_find(x>=(a+1));
if or(k) then
  // Continued fraction for x >= a+1
  %v1=size(k)
  a0 = ones(%v1(1),%v1(2));
  // mtlb_e(x,k) may be replaced by x(k) if x is a vector.
  a1 = mtlb_e(x,k);
  %v1=size(k)
  b0 = zeros(%v1(1),%v1(2));
  b1 = a0;
  fac = 1;
  n = 1;
  g = b1;
  gold = b0;
  if prod(size(a))==1 then
    while norm(g-gold,'inf')>=10*%eps*norm(g,'inf') then
      gold = g;
      ana = n-a;
      a0 = (a1+a0*ana) .* fac;
      b0 = (b1+b0*ana) .* fac;
      anf = n*fac;
      // mtlb_e(x,k) may be replaced by x(k) if x is a vector.
      a1 = mtlb_e(x,k) .* a0+anf .* a1;
      // mtlb_e(x,k) may be replaced by x(k) if x is a vector.
      b1 = mtlb_e(x,k) .* b0+anf .* b1;
      fac = 1 ./ a1;
      g = b1 .* fac;
      n = n+1;
      // mtlb_e(x,k) may be replaced by x(k) if x is a vector.
      // mtlb_e(x,k) may be replaced by x(k) if x is a vector.
      b(k) = 1-exp(-mtlb_e(x,k)+a*log(mtlb_e(x,k))-lngama) .* g;
    end
  else
    while norm(g-gold,'inf')>=10*%eps*norm(g,'inf') then
      gold = g;
      // mtlb_e(a,k) may be replaced by a(k) if a is a vector.
      ana = n-mtlb_e(a,k);
      a0 = (a1+a0 .* ana) .* fac;
      b0 = (b1+b0 .* ana) .* fac;
      anf = n*fac;
      // mtlb_e(x,k) may be replaced by x(k) if x is a vector.
      a1 = mtlb_e(x,k) .* a0+anf .* a1;
      // mtlb_e(x,k) may be replaced by x(k) if x is a vector.
      b1 = mtlb_e(x,k) .* b0+anf .* b1;
      fac = 1 ./ a1;
      g = b1 .* fac;
      n = n+1;
      // mtlb_e(x,k) may be replaced by x(k) if x is a vector.
      // mtlb_e(a,k) may be replaced by a(k) if a is a vector.
      // mtlb_e(x,k) may be replaced by x(k) if x is a vector.
      // mtlb_e(a,k) may be replaced by a(k) if a is a vector.
      b(k) = 1-exp(-mtlb_e(x,k)+mtlb_e(a,k) .* log(mtlb_e(x,k))-gammaln(mtlb_e(a,k))) .* g;
    end
  end
end
 

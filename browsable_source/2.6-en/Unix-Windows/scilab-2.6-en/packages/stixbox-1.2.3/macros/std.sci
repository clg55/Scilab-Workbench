function [y]=std(x)
// 
// last update: dec 2001 (jpc)
//
  [m,n] = size(x);
  if m==1 | n==1 then
    m = max(m,n);
    y = norm(x- sum(x)/m);
  else
     avg = sum(x,'r')/m;
     y = zeros(avg)
     for i = 1:n
       y(i) = norm(x(:,i)-avg(i));
     end
  end
  if m==1 then
    y = 0;
  else
     y = y/sqrt(m-1);
  end
endfunction 

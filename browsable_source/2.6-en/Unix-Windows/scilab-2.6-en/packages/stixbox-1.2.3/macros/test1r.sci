function [pval,r]=test1r(x)
pval=[];r=[];
//TEST1R   Test for median equals 0 using rank test
// 
//         [pval, ranksum] = test1r(x)
// 
//         This is called the signed rank test. It is two sided.
//         If you want a one sided alternative then devide pval by 2.
 
//       Anders Holtsberg, 18-11-93
//       Copyright (c) Anders Holtsberg
 
x = x(:);
x = x(find(x~=0)');
n = mtlb_length(x);
F = zeros(1,ceil((n*(n+1)/2+1)/2));
F(1) = 1;
for i = 1:n
  B = [0.5,zeros(1,i-1),0.5];
  F = mtlb_filter(B,1,F);
end
 
s = x>0;
[x,I] = sort(abs(x))
x = x($:-1:1)
I = I($:-1:1)
J = s(I);
J = find(J)';
r = 1:n;
r = sum(r(J));
r = min(r,n*(n+1)/2-r);
pval = min(2*sum(F(1:r+1)),1);

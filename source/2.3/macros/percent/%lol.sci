function [r]=%lol(l1,l2)
//l1==l2
//!
n1=size(l1)
r=n1==size(l2)
if r then
 for i=1:n1,
   if l1(i)==l2(i) then
     r(1,i)= %t
   else
     r(1,i)= %f
   end
 end
end




function [stk,txt,top]=sci_triu()
// Copyright INRIA
txt=[]
if rhs==2 then
  s1=stk(top-1)
  stk=list('triu('+s1(1)+','+stk(top)(1)+')','0',s1(3),s1(4),s1(5),'?')
  top=top-1
else
  s1=stk(top)
  stk=list('triu('+s1(1)+')','0',s1(3),s1(4),s1(5),'?')
end

function [stk,txt,top]=sci_feval()
// Copyright INRIA
txt=[]
RHS=[]
for k=2:rhs
  RHS=[RHS stk(top-rhs+k)(1)]
end
if lhs==1 then
  stk=list('evstr('+stk(top-rhs+1)(1)+'+'+sci2exp(rhsargs(RHS))+')','0','?','?','?')
  top=top-rhs+1
else
  LHS=[]
  for k=1:lhs,   LHS=[LHS,lst(ilst+k)(2)],end
  fname=stk(top-rhs+1)(1)
  txt='execstr('+sci2exp(lhsargs(LHS)+' = '+fname+rhsargs(RHS))+')'
  stk=list()
  for k=1:lhs,stk(k)=list(' ','-2','0','?','?','?'),end
  top=top-rhs+1
end



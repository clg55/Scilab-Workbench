function [stk,txt,top]=sci_plot()
// Copyright INRIA
txt=[]
RHS=[]
for k=1:rhs
  RHS=[stk(top)(1),RHS]
  top=top-1
end
top=top+1
stk=list('mtlb_plot'+'('+makeargs(RHS)+')','0','?','?','?')

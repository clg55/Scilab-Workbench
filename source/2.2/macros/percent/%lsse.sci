function [f1,f2,f3,f4,f5,f6,f7]=%lsse(i,j,f)
// f= f(i,j)
//!
// origine s. steer inria 1988
//
if type(i)==10 then
  [lhs,rhs]=argn(0)
  if rhs<>2 then  error(21),end
  nams=['A','B','C','D','X','dt']
  for k=1:prod(size(i))
    kf=find(i(k)==nams)
    if kf==[] then error(21),end
    execstr('f'+string(k)+'=j(kf+1)')
  end
  return
end
if type(i)==4 then i=find(i),end
if type(j)==4 then j=find(j),end

if i==[]|j==[] then f=[],return,end
[a,b,c,d,x0,dom]=f(2:7)
f1=tlist('lss',a,b(:,j),c(i,:),d(i,j),x0,dom)




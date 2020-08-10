function [nart]=articul(i,g)
[lhs,rhs]=argn(0)
n=g('node_number')
if rhs==1 then
  g=i
  i=1
elseif rhs==2 then
  // check i
  if (i<1|i>n) then
    error(string(i)+' is not a node number')
  end
else error(39)
end
// check g
check_graph(g)
// compute lp, la and ls
ma=prod(size(g('tail')))
[lp,la,ls]=m6ta2lpu(g('tail'),g('head'),n+1,n,2*ma)
// compute articulation nodes
[nart,iart]=m6dfs2(i,lp,ls,n)
if iart==0|iart==1 then
  nart=[]
else
  nart=nart(1:iart-1)
end

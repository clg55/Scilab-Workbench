function p=find_path(i,j,g)
[lhs,rhs]=argn(0)
if rhs<>3 then error(39), end
// check i and j
if prod(size(i))<>1 then
  error('find_path: first argument must be a scalar')
end
if prod(size(j))<>1 then
  error('find_path: second argument must be a scalar')
end
// check g
check_graph(g)
// compute lp, la and ls
n=g('node_number')
ma=g('edge_number')
if g('directed')==1 then
  [lp,la,ls]=ta2lpd(g('tail'),g('head'),n+1,n)
else
  [lp,la,ls]=ta2lpu(g('tail'),g('head'),n+1,n,2*ma)
end
// compute path
[l,v]=dfs(i,lp,ls,n)
p=prevn2p(i,j,v,la,lp,ls,g('directed'))

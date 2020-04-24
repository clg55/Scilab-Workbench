function [p]=perctl(x,y)
//
//
//compute the matrix p  of percentils (in increasing  order,
//column first) of the real  vector or matrix x indicated by
//the entries of  y, the  values of entries   of  y must  be
//positive integers between 0 and 100.  p  is a matrix whose
//type is length(y)x2 and   the content of its first  column
//are the  percentils values.   The contents of   its second
//column  are the places  of the computed percentiles in the
//input matrix x.
//
//author: carlos klimann
//
//date: 1999-04-14
//
  [lhs,rhs]=argn(0)
  if rhs<>2 then
    error('perctl requires two arguments exactly');end
    if x==[]|y==[] then p=[];return;end
    if find((y-int(y)))<>[]|max(y)>100|min(y)<1 then
      error('the second input parameter must consist of natural numbers between 1 and 100')
    end
    if type(x)<>1 then
      error('first parameter must be numerical')
    end
    lenx=size(x)
    lx=prod(lenx)
    [val,pos]=sort(x)
    x1=[matrix(val,lx,1) matrix(pos,lx,1)]
    x1=x1(lx-[0:lx-1],:)
    ly=length(y)
    y=sort((matrix(y,ly,1)/100)*(lx+1))
    y=y(ly-[0:ly-1])
    p=x1(floor(y),:)
    w=find(ceil(y)-floor(y)<>0)
    p(w,1)=((x1(ceil(y),1)-x1(floor(y),1)).*(y-floor(y))+x1(floor(y),1))
endfunction

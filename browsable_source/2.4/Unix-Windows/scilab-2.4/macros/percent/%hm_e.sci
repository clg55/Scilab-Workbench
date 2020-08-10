function M=%hm_e(varargin)
// Copyright INRIA
//extract an sub_hypermatrix
[lhs,rhs]=argn(0)
M=varargin(rhs)
dims=M('dims')
v=M('entries');v=v(:)


if rhs-1>size(dims,'*') then
  error('Too many subscripts')
end
dims1=[]
I=0
for k=rhs-1:-1:1
  ik=varargin(k)
  if type(ik)==2 |type(ik)==129 then // size implicit subscript $...
    ik=horner(ik,dims(k)) // explicit subscript
  elseif type(ik)==4 then // boolean subscript
    ik=find(ik)
  elseif mini(size(ik))<0 then // :
    if rhs==2 then
      M=v
      return
    end
    ik=1:dims(k)
  end
  dims1=[size(ik,'*');dims1]
  if size(ik,'*')>1 then
    ik=ik(:)
    if size(I,'*')>1 then
      I=(dims(k)*I).*.ones(ik)+ones(I).*.(ik-1)
    else
      I=dims(k)*I+ik-1
    end
  else
    I=dims(k)*I+ik-1
  end
end
//
dims1(max(find(dims1>1))+1:$)=[]


while  dims1($)==1 then dims1($)=[],end
select size(dims1,'*')
case 0
  M=v(I+1)
case 1
  M=v(I+1)
case 2
  M=matrix(v,dims1(1),dims1(2))
else
  M=mlist(['hm','dims','entries'],dims1,v)
end





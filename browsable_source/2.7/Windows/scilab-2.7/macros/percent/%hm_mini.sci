function x=%hm_mini(varargin)
n=size(varargin)
if n==1 then
  x=min(varargin(1).entries)
else
  if n==2 then
    d=varargin(2)
    if type(d)==1|type(d)==10 then
      x=%hm_oriented_min(varargin(1),d)
      return
    end
  end
  x=varargin(1).entries
  dims=varargin(1).dims
  for k=2:n
    if or(dims<>varargin(k).dims) then 
      if prod(dims)<>1&prod(varargin(k).dims)<>1 then
	error(42)
      end
      if prod(dims)==1 then dims=varargin(k).dims,end
    end
    x=min(x,varargin(k).entries)
  end
  x=hypermat(dims,x)
end


endfunction
function x=%hm_oriented_min(m,d)
if d=='r' then 
  d=1
elseif d=='c' then
  d=2
end
dims=m.dims;
if type(dims==8) then flag=1; dims=double(dims); else flag=0;end
N=size(dims,'*');
p1=prod(dims(1:d-1));// step for one min
p2=p1*dims(d);//step for beginning of vector to min 
ind=(0:p1:p2-1)';// selection for vector to min
deb=(1:p1);
I=ind*ones(deb)+ones(ind)*deb 

ind=(0:p2:prod(dims)-1);
I=ones(ind).*.I+ind.*.ones(I)

x=min(matrix(m.entries(I),dims(d),-1),'r')

dims(d)=1
if d==N then
  dims=dims(1:$)
else
  dims(d)=1
end
if size(dims,'*')==2 then
  if flag==1 then dims=int32(dims);return;end
  x=matrix(x,dims(1),dims(2))
else
  if flag==1 then dims=int32(dims);return;end
  x=hypermat(dims,x(:))
end
endfunction

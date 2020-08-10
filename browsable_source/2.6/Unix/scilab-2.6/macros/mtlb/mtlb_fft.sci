function r=mtlb_fft(x,n,job)
// Copyright INRIA
[lhs,rhs]=argn(0)
if rhs<2 then n=[],end
if rhs==3 then //row or column-wise fft
  select job
  case 1 then //row-wise
    if n<>[] then //pad or truncate
      s=size(x,1)
      if s>n then //truncated fft
	x=x(1:n,:)
      elseif s<n then //padd with zeros
	x(n,:)=0
      end
    end  
    r=[]
    for xk=x
      r=[r fft(xk,-1)]
    end
  case 2 then //column-wise
    if n<>[] then //pad or truncate
      s=size(x,2)
      if s>n then //truncated fft
	x=x(:,1:n)
      elseif s<n then //padd with zeros
	x(:,n)=0
      end
    end  
    r=[]
    for k=1:size(x,1)
      r=[r;fft(x(k,:),-1)]
    end
  end
else 
  if mini(size(x))==1 then  //fft of a vector
    if n<>[] then //pad or truncate
      s=size(x,'*')
      if s>n then //truncated fft
	x=x(1:n)
      elseif s<n then //padd with zeros
	x(n)=0
      end
    end  
    r=fft(x,-1)
  else //row-wise fft
    if n<>[] then //pad or truncate
      s=size(x,1)
      if s>n then //truncated fft
	x=x(1:n,:)
      elseif s<n then //padd with zeros
	x(n,:)=0
      end
    end
    r=[]
    for xk=x
      r=[r fft(xk,-1)]
    end
  end  
end


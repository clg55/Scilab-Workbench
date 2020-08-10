function [model,graphics,ok]=check_io(model,graphics,in,out,clkin,clkout)
// check_io first check if given number of ports agree with block connection
// and then changes block structure
//%parameters
// model   : initial and resulting block model structure
// graphics: initial and resulting block graphics structure
// in      : new input ports sizes
// nout    : new output ports sizes
// nclkin  : new event input ports sizes
// nclkout : new event output ports sizes
// ok      : error flag
//           ok==%f : some of input parameters are incorrects or
//                    attempt to add/delete ports when some are connected
//           ok==%t  : changes of block structure has been performed
//!
// Copyright INRIA
in=int(in(:));nin=size(in,1)

out=int(out(:));nout=size(out,1);

clkin=int(clkin(:));nclkin=size(clkin,1);
if nclkin>0 then
  if mini(clkin)<1 then
    message('Event input ports sizes must be positive')
    ok=%f
    return
  end
end


clkout=int(clkout(:));nclkout=size(clkout,1);
if nclkout>0 then
  if mini(clkout)<1 then
    message('Event output ports sizes must be positive')
    ok=%f
    return
  end
end



[label,ip1,op1,cip1,cop1]=graphics(4:8)

[in1,out1,clkin1,clkout1]=model(2:5)

n1=size(in1,'*');n=size(in,'*')
if n1>n then
  if or(ip1(n+1:$)>0) then
    message('Connected ports cannot be suppressed')
    ok=%f
    return
  end
  ip1=ip1(1:n)
else
  ip1=[ip1;zeros(n-n1,1)]
end

n1=size(out1,'*');n=size(out,'*')
if n1>n then
  if or(op1(n+1:$)>0) then
    message('Connected ports cannot be suppressed')
    ok=%f
    return
  end
  op1=op1(1:n)
else
  op1=[op1;zeros(n-n1,1)]
end

n1=size(clkin1,'*');n=size(clkin,'*')
if n1>n then
  if or(cip1(n+1:$)>0) then
    message('Connected ports cannot be suppressed')
    ok=%f
    return
  end
  cip1=cip1(1:n)
else
  cip1=[cip1;zeros(n-n1,1)];
end

n1=size(clkout1,'*');n=size(clkout,'*')
if n1>n then
  if or(cop1(n+1:$)>0) then
    message('Connected ports cannot be suppressed')
    ok=%f
    return
  end
  cop1=cop1(1:n);
else
  cop1=[cop1;zeros(n-n1,1)];
end

ok=%t
graphics(5)=ip1
graphics(6)=op1
graphics(7)=cip1
graphics(8)=cop1
model(2)=in
model(3)=out
model(4)=clkin
model(5)=clkout





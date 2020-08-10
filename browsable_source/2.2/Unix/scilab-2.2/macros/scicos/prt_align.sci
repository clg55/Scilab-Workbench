function x=prt_align(x)
while %t
  [n,pt]=getmenu(datam);xc1=pt(1);yc1=pt(2)
  if n>0 then n=resume(n),end
  //[btn,xc1,yc1]=xclick()
  k1=getblock(x,[xc1;yc1])
  if k1<>[] then o1=x(k1);break,end
end
//
while %t
  [btn,xc2,yc2]=xclick()
  k2=getblock(x,[xc2;yc2])
  if k2<>[] then o2=x(k2);break,end
end
if get_connected(x,k2)<>[] then
  x_message('Connected block can''t be aligned')
  return
end
//
[xout,yout,typout]=getoutputs(o1)
[xin,yin,typin]=getinputs(o1)
xx1=[xout xin]
yy1=[yout,yin]
[m,kp1]=mini((yc1-yy1)^2+(xc1-xx1)^2)
//
[xout,yout,typout]=getoutputs(o2)
[xin,yin,typin]=getinputs(o2)
xx2=[xout xin]
yy2=[yout,yin]
[m,kp2]=mini((yc2-yy2)^2+(xc2-xx2)^2)
//
xx1=xx1(kp1);yy1=yy1(kp1)
xx2=xx2(kp2);yy2=yy2(kp2)

graphics2=o2(2);orig2=graphics2(1)
if abs(xx1-xx2)<abs(yy1-yy2) then //align vertically
  orig2(1)=orig2(1)-xx2+xx1
else //align horizontally
  orig2(2)=orig2(2)-yy2+yy1
end
graphics2(1)=orig2
drawobj(o2) // rubbout block
o2(2)=graphics2
drawobj(o2)
x(k2)=o2

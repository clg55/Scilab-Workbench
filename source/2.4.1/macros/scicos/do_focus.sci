function wdm=do_focus(scs_m)
// Copyright INRIA
[btn,xc,yc,win,Cmenu]=getclick()
if Cmenu<>[] then
  Cmenu=resume(Cmenu)
end

wpar=scs_m(1);wdm=wpar(1)
if size(wdm,'*')<6 then wdm(3)=0;wdm(4)=0;wdm(5)=wdm(1);wdm(6)=wdm(2);end
Xshift=wdm(3)
Yshift=wdm(4)
[ox,oy,w,h,ok]=get_rectangle(xc,yc)
if ~ok then return;end

Xshift=xc
Yshift=yc-h
wdm(5)=w;wdm(6)=h



wdm(3)=Xshift;wdm(4)=Yshift;


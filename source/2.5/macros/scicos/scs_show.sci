function scs_show(scs_m,win)
// Copyright INRIA
oldwin=xget('window')
xset('window',win);xbasc()
wpar=scs_m(1)
wsiz=wpar(1)
if MODE_X then 
options=scs_m(1)(7)
set_background()

  xset('wdim',wsiz(1),wsiz(2))
rect=dig_bound(scs_m)

wa=(rect(3)-rect(1))
ha=(rect(4)-rect(2))
aa=wa/ha
rr=wsiz(1)/wsiz(2)

if aa<rr then 
  wa2=wa*rr/aa;rect(1)=rect(1)-(wa2-wa)/2;rect(3)=rect(1)+wa2
else
  ha2=ha*aa/rr;rect(2)=rect(2)-(ha2-ha)/2;rect(4)=rect(2)+ha2
end


dxx=(rect(3)-rect(1))/20;
dyy=(rect(4)-rect(2))/20;
rect(1)=rect(1)-dxx;rect(3)=rect(3)+dxx;
rect(2)=rect(2)-dyy;rect(4)=rect(4)+dyy;
xsetech([-1 -1 8 8]/6,rect)

xset('alufunction',3)
scs_m(1)(2)(1)='Scilab Graphics of '+scs_m(1)(2)(1)
drawobjs(scs_m),


if pixmap then xset('wshow'),end
else
options=scs_m(1)(7)
set_background()
  xset('wdim',wsiz(1),wsiz(2))
if size(wsiz,'*')<5 then wsiz(5)=wsiz(1);wsiz(6)=wsiz(2);end
f_xsetech(wsiz)

drawobjs(scs_m)
end



function scs_m=do_stupidmove(scs_m)
// Copyright INRIA
rela=.1
// get a scicos object to move, and move it with connected objects
//!
//get block to move
while %t
  [btn,xc,yc,win,Cmenu]=getclick()
  if Cmenu<>[] then
    Cmenu=resume(Cmenu)
  end
  [k,wh,scs_m]=stupid_getobj(scs_m,[xc;yc])
  if k<>[] then break,end
end

scs_m_save=scs_m
if scs_m(k)(1)=='Block'|scs_m(k)(1)=='Text' then
  scs_m=stupid_moveblock(scs_m,k,xc,yc)
elseif scs_m(k)(1)=='Link' then
    scs_m=stupid_movecorner(scs_m,k,xc,yc,wh)
end
[scs_m_save,enable_undo,edited,nc_save]=resume(scs_m_save,%t,%t,needcompile)

function scs_m=stupid_moveblock(scs_m,k,xc,yc)
// Move  block k and modify connected links if any
//!
//look at connected links
dr=driver()
connectedi=[get_connected(scs_m,k,'in'),get_connected(scs_m,k,'clkin')];
connectedo=[get_connected(scs_m,k,'out'),get_connected(scs_m,k,'clkout')];
o=scs_m(k)
xx=[];yy=[];ii=[];clr=[];mx=[];my=[]

// build movable segments for all connected links
//===============================================
xm=[];ym=[];
for i=connectedi
  oi=scs_m(i)
  driver(dr)

  draw_link_seg(oi,$-1:$) //erase link
  if pixmap then xset('wshow'),end
  [xl,yl,ct,from,to]=oi([2,3,7:9])
  clr=[clr ct(1)]
  nl=prod(size(xl))
  
  if dr=='Rec' then driver('X11'),end
//  xpolys(xl($-1:$),yl($-1:$),ct(1))// redraw thin link

  xm=[xm,xl($-1:$)];ym=[ym,yl($-1:$)];
end

for i=connectedo
  oi=scs_m(i)
  driver(dr)
  draw_link_seg(oi,1:2) //erase link
  if pixmap then xset('wshow'),end
  [xl,yl,ct,from,to]=oi([2,3,7:9])
  clr=[clr ct(1)]
  nl=prod(size(xl))
  
  if dr=='Rec' then driver('X11'),end
//  xpolys(xl,yl,default_color(0))// redraw thin link

  xm=[xm,[xl(2);xl(1)]];ym=[ym,[yl(2);yl(1)]];
end

xmt=xm;ymt=ym;
// move a block and connected links
//=================================
[ff,nii]=size(connectedi)
[ff,noo]=size(connectedo)
//clr=ones(mxx,nxx)*default_color(0)
if nii+noo>0 then // move a block and connected links
  [xmin,ymin]=getorigin(o)
  xco=xc;yco=yc;
  rep(3)=-1
  [xy,sz]=o(2)(1:2)
  // clear block
  driver(dr)
  drawobj(o)
  if dr=='Rec' then driver('X11'),end
  dx=xc-xmin;dy=yc-ymin;
//  xpolys(xmt,ymt,clr)// erase moving part of links
  while rep(3)==-1 ,  // move loop
    xmt(2,:)=xm(2,:)-xco+xc; ymt(2,:)=ym(2,:)-yco+yc;
    // draw block shape
    xrect(xc-dx,yc+sz(2)-dy,sz(1),sz(2))
    // draw moving links
  xpolys(xmt,ymt,clr)// draw moving part of links
    // get new position
    if pixmap then xset('wshow'),end    
    rep=xgetmouse(0);
    // clear block shape
    xrect(xc-dx,yc+sz(2)-dy,sz(1),sz(2))
    // clear moving part of links
  xpolys(xmt,ymt,clr)// erase moving part of links
    xc=rep(1);yc=rep(2)
  end
    xy=[xc-dx,yc-dy];

  
  // update and draw block
  if rep(3)<>2 then o(2)(1)=xy;  scs_m(k)=o;end
  driver(dr)
  drawobj(o)
  if pixmap then xset('wshow'),end

j=0
for i=connectedi
  oi=scs_m(i)
  j=j+1
  oi(2)($-1:$)=xmt(:,j)
  oi(3)($-1:$)=ymt(:,j)
  scs_m(i)=oi
  draw_link_seg(oi,$-1:$) //draw link
  if pixmap then xset('wshow'),end
end

for i=connectedo
  oi=scs_m(i)
  j=j+1
  oi(2)(1:2)=xmt([2,1],j)
  oi(3)(1:2)=ymt([2,1],j)
  scs_m(i)=oi
  draw_link_seg(oi,1:2) //draw link
  if pixmap then xset('wshow'),end
end

else // move an unconnected block
  rep(3)=-1
  [xy,sz]=o(2)(1:2)
  // clear block
  drawobj(o)
  dr=driver()
  if dr=='Rec' then driver('X11'),end
  while rep(3)==-1 , //move loop
    // draw block shape
    xrect(xc,yc+sz(2),sz(1),sz(2))
    // get new position
    rep=xgetmouse(0)
    // clear block shape
    xrect(xc,yc+sz(2),sz(1),sz(2))
    xc=rep(1);yc=rep(2)
    xy=[xc,yc];
    if pixmap then xset('wshow'),end
  end
  // update and draw block
  if rep(3)<>2 then o(2)(1)=xy,scs_m(k)=o,end
  driver(dr)
  drawobj(o)
  if pixmap then xset('wshow'),end
end

function scs_m=stupid_movecorner(scs_m,k,xc,yc,wh)
o=scs_m(k)
[xx,yy,ct]=o([2 3 7])
dr=driver()

//wh=[-wh-1 -wh]

seg=[-wh-1:-wh+1]

if dr=='Rec' then driver('X11'),end

//draw_link_seg(o,seg)

xpolys(xx(seg),yy(seg),ct(1)) //draw thin link
if pixmap then xset('wshow'),end
X1=xx(seg)
Y1=yy(seg)
x1=X1;y1=Y1;

xpolys(x1,y1,ct(1)) //erase moving part of the link
rep(3)=-1

while rep(3)==-1 do
  xpolys(x1,y1,ct(1))//draw moving part of the link
  rep=xgetmouse(0);
  if pixmap then xset('wshow'),end
  xpolys(x1,y1,ct(1))//erase moving part of the link
  xc1=rep(1);yc1=rep(2)
  x1(2)=X1(2)-(xc-xc1)
  y1(2)=Y1(2)-(yc-yc1)
end
//[frect1,frect]=xgetech();
//eps=0.04*min(abs(frect(3)-frect(1)),abs(frect(4)-frect(2)))
if abs(x1(1)-x1(2))<rela*abs(y1(1)-y1(2)) then
  x1(2)=x1(1)
elseif abs(x1(2)-x1(3))<rela*abs(y1(2)-y1(3))then
  x1(2)=x1(3)
end  
if abs(y1(1)-y1(2))<rela*abs(x1(1)-x1(2)) then
  y1(2)=y1(1)
elseif abs(y1(2)-y1(3))<rela*abs(x1(2)-x1(3)) then
  y1(2)=y1(3)
end  
d=projaff([x1(1);x1(3)],[y1(1);y1(3)],[x1(2);y1(2)])
if norm(d(:)-[x1(2);y1(2)])<..
        rela*max(norm(d(:)-[x1(3);y1(3)]),norm(d(:)-[x1(1);y1(1)])) then
  xx(seg)=x1
  yy(seg)=y1
  xx(seg(2))=[]
  yy(seg(2))=[]
  x1(2)=[];y1(2)=[];seg(3)=[]
else
  xx(seg)=x1
  yy(seg)=y1
end

//xpolys(x1,y1,ct(1))//draw moving part of the link
//xpolys(xx,yy,ct(1)) //erase thin link
if rep(3)<>2 then
  o(2)=xx;o(3)=yy
  scs_m(k)=o
end
driver(dr)
draw_link_seg(o,seg)
if pixmap then xset('wshow'),end

function [k,wh,objs]=stupid_getobj(objs,pt)
n=size(objs)
wh=[];
x=pt(1);y=pt(2)
data=[]
k=[]
for i=2:n //loop on objects
  o=objs(i)
  if o(1)=='Block' then
    graphics=o(2)
    [orig,sz]=graphics(1:2)
    data=[(orig(1)-x)*(orig(1)+sz(1)-x),(orig(2)-y)*(orig(2)+sz(2)-y)]
    if data(1)<0&data(2)<0 then k=i,break,end
  elseif o(1)=='Link' then
    [frect1,frect]=xgetech();
    eps=0.01*min(abs(frect(3)-frect(1)),abs(frect(4)-frect(2)))
    xx=o(2);yy=o(3);
    [d,ptp,ind]=stupid_dist2polyline(xx,yy,pt,.85)
    if d<eps then 
       if ind==-1 then k=o(8)(1),break,
       elseif ind==-size(xx,1) then k=o(9)(1),break,
       elseif ind>0 then 

          draw_link_seg(o,[ind,ind+1])
          o(2)=[xx(1:ind);ptp(1);xx(ind+1:$)];o(3)=[yy(1:ind);ptp(2);yy(ind+1:$)];
//          draw_link_seg(o,[ind,ind+2])
          objs(i)=o
       k=i,wh=-ind-1,break,
       else k=i,wh=ind,draw_link_seg(o,[-ind-1:-ind+1]);break,end
    end
  elseif o(1)=='Text' then
    graphics=o(2)
    [orig,sz]=graphics(1:2)
    data=[(orig(1)-x)*(orig(1)+sz(1)-x),(orig(2)-y)*(orig(2)+sz(2)-y)]
    if data(1)<0&data(2)<0 then k=i,break,end
  end
end

function [d,pt,ind]=stupid_dist2polyline(xp,yp,pt,pereps)
// computes minimum distance from a point to a polyline
//d    minimum distance to polyline
//pt   coordinate of the polyline closest point
//ind  
//     if negative polyline closest point is a polyline corner:pt=[xp(-ind) yp(-ind)]
//     if positive pt lies on segment [ind ind+1]

x=pt(1)
y=pt(2)
xp=xp(:);yp=yp(:)
cr=4*sign((xp(1:$-1)-x).*(xp(1:$-1)-xp(2:$))+..
          (yp(1:$-1)-y).*(yp(1:$-1)-yp(2:$)))+..
    sign((xp(2:$)-x).*(xp(2:$)-xp(1:$-1))+..
          (yp(2:$)-y).*(yp(2:$)-yp(1:$-1)))

ki=find(cr==5) // index of segments for which projection fall inside
np=size(xp,'*')
if ki<>[] then
  //projection on segments
  x=[xp(ki) xp(ki+1)]
  y=[yp(ki) yp(ki+1)]
  dx=x(:,2)-x(:,1)
  dy=y(:,2)-y(:,1)
  d_d=dx.^2+dy.^2
  d_x=( dy.*(-x(:,2).*y(:,1)+x(:,1).*y(:,2))+dx.*(dx*pt(1)+dy*pt(2)))./d_d
  d_y=(-dx.*(-x(:,2).*y(:,1)+x(:,1).*y(:,2))+dy.*(dx*pt(1)+dy*pt(2)))./d_d
  xp=[xp;d_x]
  yp=[yp;d_y]
end

zzz=[ones(np,1);zeros(size(ki,'*'),1)]*eps
zz=[ones(np,1)*pereps;ones(size(ki,'*'),1)]
[d,k]=min(sqrt((xp-pt(1)).^2+(yp-pt(2)).^2).*zz-zzz) 
pt(1)=xp(k)
pt(2)=yp(k)
if k>np then ind=ki(k-np),else ind=-k,end




function draw_link_seg(o,seg)
  ct=o(7);c=ct(1),pos=o(6)
  if pos(2)>=0 then
    d=xget('dashes')
    thick=xget('thickness')
    t=maxi(pos(1),1)*maxi(pos(2),1)
    xset('thickness',t)
    xset('dashes',c)
    xpoly(o(2)(seg),o(3)(seg),'lines')
    xset('dashes',d)
    xset('thickness',thick)
  end














xsetech([0 0 1 1],[0 0 1 1])
orig=[0 0]
sz=[1 1]

thick=xget('thickness');xset('thickness',2);
xrect(orig(1)+sz(1)/10,orig(2)+(1-1/10)*sz(2),sz(1)*8/10,sz(2)*8/10);
xx=[orig(1)+sz(1)/5,orig(1)+sz(1)/5;
orig(1)+(1-1/5)*sz(1),orig(1)+sz(1)/5];
yy=[orig(2)+sz(2)/5,orig(2)+sz(2)/5;
orig(2)+sz(2)/5,orig(2)+(1-1/5)*sz(2)];
xarrows(xx,yy);
t=(0:0.3:2*%pi)'
xx=orig(1)+(1/5+3*t/(10*%pi))*sz(1);
yy=orig(2)+(1/4.3+(sin(t)+1)*3/10)*sz(2);
xpoly(xx,yy,'lines');
xset('thickness',thick)



orig=[0.5 0.5]



wd=xget('wdim').*[1.016,1.12];
thick=xget('thickness');xset('thickness',2);
p=wd(2)/wd(1);p=1;
rx=sz(1)*p/2;ry=sz(2)/2;
xarcs([orig(1)+0.05*sz(1);
orig(2)+0.95*sz(2);
   0.9*sz(1)*p;
   0.9*sz(2);
   0;
   360*64],default_color(-1));
xset('thickness',1);
xx=[orig(1)+rx    orig(1)+rx;
    orig(1)+rx    orig(1)+rx+0.6*rx*cos(%pi/6)];
yy=[orig(2)+ry    orig(2)+ry ;
  orig(2)+1.8*ry  orig(2)+ry+0.6*ry*sin(%pi/6)];
xsegs(xx,yy,10);
xset('thickness',thick);

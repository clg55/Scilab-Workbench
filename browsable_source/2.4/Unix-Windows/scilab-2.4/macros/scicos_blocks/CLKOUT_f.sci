function [x,y,typ]=CLKOUT_f(job,arg1,arg2)
// Copyright INRIA
x=[];y=[];typ=[];
select job
case 'plot' then
  xf=60
  yf=40
  graphics=arg1(2); [orig,sz,orient]=graphics(1:3)
  model=arg1(3);prt=model(9)
  pat=xget('pattern');xset('pattern',default_color(-1))
  thick=xget('thickness');xset('thickness',2)
  if orient then
    x=orig(1)+sz(1)*[0;0;1/1.5;1;  1/1.5]
    y=orig(2)+sz(2)*[0;1;1;    1/2;0    ]
    xstringb(orig(1),orig(2),string(prt),sz(1)/1.5,sz(2))
    in= [-1/7  -1/14
        0    0
        -1/7   1/14
        -1/7  -1/14]*diag([xf,yf])
    xfpoly(in(:,1)+ones(4,1)*orig(1),..
        in(:,2)+ones(4,1)*(orig(2)+sz(2)-sz(2)/2),1)
  else
    x=orig(1)+sz(1)*[0  ;1/3;1;1;1/3]
    y=orig(2)+sz(2)*[1/2;1  ;1;0;0]
    xstringb(orig(1)+sz(1)/3,orig(2),string(prt),sz(1)/1.5,sz(2))
    in= [1/7  -1/14
        0    0
        1/7   1/14
        1/7  -1/14]*diag([xf,yf])
    xfpoly(in(:,1)+ones(4,1)*(orig(1)+sz(1)),..
        in(:,2)+ones(4,1)*(orig(2)+sz(2)-sz(2)/2),1)
  end
  xpoly(x,y,'lines',1)
  xset('thickness',thick)
  xset('pattern',pat)
    //identification
  if size(o(3)) >= 15 then
    ident = o(3)(15)
  else
    ident = []
  end
  if ident <> [] then
    font=xget('font')
    xset('font', options('ID')(1)(1), options('ID')(1)(2))
    rectangle = xstringl(orig(1)+3/2*sz(1), orig(2), ident)
    w = rectangle(3)
    h = rectangle(4)
    xstringb(orig(1) - sz(1) /2 - w, orig(2) + sz(2) * 0.5 , ident , w, h)
    xset('font', font(1), font(2))
  end
case 'getinputs' then
  graphics=arg1(2)
  [orig,sz,orient]=graphics(1:3)
  if orient then
    x=orig(1)
    y=orig(2)+sz(2)/2
  else
    x=orig(1)+sz(1)
    y=orig(2)+sz(2)/2
  end
  typ=-ones(x) //undefined type
case 'getoutputs' then
  x=[];y=[];typ=[];
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  [graphics,model]=arg1(2:3);
  label=graphics(4);
  label=label(1) //for compatibility
    while %t do
    [ok,prt,label]=getvalue('Set Event Output block parameters',..
	'Port number',list('vec',1),label)
    if ~ok then break,end
    prt=int(prt)
    if prt<=0 then
      message('Port number must be a positive integer')
    else
      model(9)=prt
      model(4)=1
      model(11)=[]//compatibility
      graphics(4)=label
      x(2)=graphics;
      x(3)=model
      break
    end
  end
case 'define' then
  prt=1
  model=list('output',[],[],1,[],[],[],[],prt,'d',[],[%f %f],' ',list())
  label=string(prt)
  x=standard_define([1 1],model,label,[])
end









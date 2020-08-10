function [v]=identify(x,y,arg3,arg4)
v=[];
[nargout,nargin] = argn(0)
//IDENTIFY  Identify points on a plot by clicking with the mouse.
// 
//          v = identify(x,y)
// 
//	   This routine plots x versus y and waits for mouse clicks
//	   to identify points. Click with left button on points and
//	   end with middle button. Plotsymbol and text strings are
//	   optional input arguments.
 
//       Anders Holtsberg, 14-12-94
//       Copyright (c) Anders Holtsberg
 
plotsymbol = '*';
textvector = 1:mtlb_length(x);
for i = 3:nargin
  if i==3 then
    A = arg3;
  else
    A = arg4;
  end
  if mtlb_length(A)==1 then
    plotsymbol = A;
  elseif mtlb_length(A)==mtlb_length(x) then
    if min(size(A))==1 then
      A = A(:);
    end
    textvector = A;
  else
    error('Argument incompatibility');
  end
end

//mtlb_plot(x,y,plotsymbol);
if nargin > 2 then
  plot2d(x,y,-3,'000')
else
plot2d(x,y,-9)
end;
cx = cov(x);
cy = cov(y);
v = [];
B = 1;
while B==1 then
//  [xc,yc,B] = mtlb_ginput(1);
  [B,xc,yc]=xclick();B=B+1;
  if B==1 then
    d = (x-xc).^2/cx+(y-yc).^2/cy;
    %v2 = d
    if min(size(%v2))==1 then 
      [d,i]=sort(%v2)
    else 
      [d,i]=sort(%v2,'r')
    end
    d = d($:-1:1)
    i = i($:-1:1)
    i = i(1);
    v = [v;i];
//    hold('on');
    if type(textvector)==10 then
      xstring(xc,yc,textvector(i,:));
    else
      xstring(xc,yc,sprintf(' %g',textvector(i)));
    end
  end
end
//hold('off');

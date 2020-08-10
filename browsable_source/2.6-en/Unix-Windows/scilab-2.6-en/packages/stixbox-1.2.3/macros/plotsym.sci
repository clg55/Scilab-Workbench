function []=plotsym(x,y,a3,a4,a5,a6,a7)
[nargout,nargin] = argn(0)
//PLOTS    Plot with symbols
// 
//	  plotsym(x,y,S)
//	  plotsym(x,y,s,S,c,C,symsize)
// 
//	  Input S is one of the following
// 
//	  's'  square
//         'd'  diamond
//         't'  triangle
//	  'i'  inverted triangle
//	  'l'  left triangle
//	  'r'  right triangle
//	  'c'  circle
//	
//	  In the longer call s is vector that contains category marker that
//	  is plotted with symbol from text string S, i.e element i is
//	  plotted with symbol S(s(i)), c is vector for colormarking, and
//	  C is corresponding string of 'rgbcymwk' in permuted order. If C
//	  is omitted then c is taken as a colour in itself. The colors
//	  may then be changed by calling colormap. The input symsize
//	  defines the symbol size relative to the default size which is 1.
//	  It may be a scalar, which is then applied to all symbols, or a
//	  vector, one for each symbol. Examples:
// 
//	  plotsym(x,y,z,'st','rb')
//	     Points x,y are plotted with red squares (z=1) or blue
//	     triangles (z=2).
// 
//	  plotsym(x,y,'s',z,2)
//	     Points x,y are plotted with squares of twice the standard
//	     size, filled with colors according to value in z and current
//	     colormap.
// 
//	  See also PLOT and COLORMAP
 
x = x(:);
y = y(:);
n = mtlb_length(x);
 
symbol = ones(n,1);
symboltable = 'stcidlr';
color = [];
colortable = [];
symsize = ones(n,1);
 
s1 = 1;
s2 = 1;
for i = 3:nargin
  v = evstr(['a'+string(i)]);
  if type(v)==10 then
    if s1==1 then
      symboltable = v;
      s1 = 2;
      s2 = 2;
    else
      colortable = v;
      s2 = 3;
    end
  else
    if s2==1 then
      symbol = v;
      s2 = 2;
    elseif s2==2 then
      color = v;
      s2 = 3;
    else
      symsize = v;
    end
  end
end

if color==[] then
  if colortable==[] then
    colortable = 'rbgcmywk';
  end
  %v1$1 = symbol-1
  %v1$1 = mtlb_length(colortable)
  // mtlb_e(colortable,%v1$1-fix(%v1$1./%v1$1).*%v1$1+1) may be replaced by colortable(%v1$1-fix(%v1$1./%v1$1).*%v1$1+1) if colortable is a vector.
  color = mtlb_e(colortable,%v1$1-fix(%v1$1./%v1$1).*%v1$1+1);
  color = color(:);
elseif colortable~=[] then
  // mtlb_e(colortable,color) may be replaced by colortable(color) if colortable is a vector.
  color = mtlb_e(colortable,color);
elseif mtlb_length(color)<mtlb_length(x) then
  // mtlb_e(color,symbol) may be replaced by color(symbol) if color is a vector.
  color = mtlb_e(color,symbol);
end
// mtlb_e(symboltable,symbol) may be replaced by symboltable(symbol) if symboltable is a vector.
symbol = mtlb_e(symboltable,symbol);
if mtlb_length(symsize)==1 then
  symsize = symsize(ones(n,1));
end
 
ishold=%F;
//A VOIR
if ~ishold then
  xbasc();
  xx0=floor(min(x));xx1=ceil(max(x));
  yy0=floor(min(y));yy1=ceil(max(y));  
//  plot2d([0],[0],[1],"012"," ",[xx0,yy0,xx1,yy1],[2,10,2,10]);
  plot2d1('enn',0,0,1,'011',' ',[xx0,yy0,xx1,yy1],[2,10,2,10])
  sx = max(x)-min(x);
  sy = max(y)-min(y);
else
  a = axis;
  sx = max([a(2);x])-min([a(1);x]);
  sy = max([a(4);y])-min([a(3);y]);
end
//P = get(gca(),'Position');
P=[0.12 0.12 0.76 0.76];
P = P(3)/P(4);
dx = sx/25/P/1.3;
dy = sy/25;
 
Ss = [-1,1,1,-1;-1,-1,1,1]/4;
Ds = [-1,0,1,0;0,-1,0,1]/2/sqrt(2);
Ts = [-sqrt(3)/2,0,sqrt(3)/2;0.5,-1,0.5]/sqrt(3)/1.5;
Is = [-sqrt(3)/2,0,sqrt(3)/2;-0.5,1,-0.5]/sqrt(3)/1.5;
Ls = [0.5,-1,0.5;-sqrt(3)/2,0,sqrt(3)/2]/sqrt(3)/1.5;
Rs = [-0.5,1,-0.5;-sqrt(3)/2,0,sqrt(3)/2]/sqrt(3)/1.5;
Cs = [sin(%pi*(0:31)/16);cos(%pi*(0:31)/16)]/%pi;

for i = 1:n
  si = part(symbol,i);
  if si=='s' then
    sym = Ss;
  elseif si=='d' then
    sym = Ds;
  elseif si=='t' then
    sym = Ts;
  elseif si=='i' then
    sym = Is;
  elseif si=='l' then
    sym = Ls;
  elseif si=='r' then
    sym = Rs;
  elseif si=='c' then
    sym = Cs;
  end
  XX=x(i)+dx*symsize(i)*sym(1,:);
  YY=y(i)+dy*symsize(i)*sym(2,:);
  if color == 'k',
  xset('pattern',1);
  end;
  if prod(size(color)) <> 1,
    xset('pattern',color(i));
  end
  xfpoly(XX,YY,1);
  
//  p = patch(x(i)+dx*symsize(i)*sym(1,:),y(i)+dy*symsize(i)*sym(2,:),color(i));
//  set(p,'EdgeColor',[1,1,1]);
end

 
//set(gca(),'Box','on');

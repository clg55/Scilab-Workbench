function [J]=pairs(X,plotsymbol,diagonal)
J=[];
[nargout,nargin] = argn(0)
//PAIRS    Pairwise scatter plots.
// 
//	  pairs(X)
//         pairs(X,plotsymbol,diagonal)
// 
//	  The columns of X are plotted versus each other. An optional
//	  second argument is plotting symbol and a third argument is
//	  1 (2) if only upper (lower) triangle should be plotted.
 
//       Anders Holtsberg, 14-12-94
//       Copyright (c) Anders Holtsberg
 
clg = clg;
[n,p] = size(X);
X = X-ones(n,1)*mtlb_min(X);
X = X ./ (ones(n,1)*mtlb_max(X));
if nargin<3 then
  diagonal = 0;
end
if nargin<2 then
  if n*p<100 then
    plotsymbol = 'o';
  else
    plotsymbol = '.';
  end
end
bf = 0.1;
ffs = 0.05/(p-1);
ffl = (1-2*bf-0.05)/p;
fL = linspace(bf,1-bf+ffs,p+1);
for i = 1:p
  for j = 1:p
    if diagonal==0|(diagonal==1)&(j<=i)|(diagonal==2)&(j>=i) then
      h = axes('position',[fL(i),fL(p+1-j),ffl,ffl]);
      if i==j then
        histo(X(:,i));
        set(gca(),'XLim',[-0.1,1.1000000000000001]);
      else
        mtlb_plot(X(:,i),X(:,j),plotsymbol);
        axis([-0.1,1.1000000000000001,-0.1,1.1000000000000001]);
      end
      set(gca(),'XTickLabels',[],'XTick',[]);
      set(gca(),'YTickLabels',[],'YTick',[]);
      if i==1 then
        xtitle(' ',' ',0);
      end
      if j==1 then
        xtitle(string(i),' ',' ');
      end
      drawnow = drawnow;
    end
  end
end

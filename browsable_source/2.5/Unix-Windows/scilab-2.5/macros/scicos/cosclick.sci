function [btn,xc,yc,win,Cmenu]=cosclick(flag)
// Copyright INRIA
[lhs,rhs]=argn(0)
Cmenu=[]

if ~or(winsid()==curwin) then  Cmenu='Quit (q)',return,end    
if rhs==1 then
  [btn,xc,yc,win,str]=xclick(flag)
else
  [btn,xc,yc,win,str]=xclick()
end

if btn==-100 then  
  if win==curwin then
    Cmenu='Quit (q)',
  else
    Cmenu='Open/Set (o)'
  end
  return
end    
if btn==-2 then
  // click in a dynamic menu
  xc=0;yc=0
  execstr('Cmenu='+part(str,9:length(str)-1))
  execstr('Cmenu='+Cmenu)
  return
end
if btn==0&(Cmenu==[]|Cmenu=='Open/Set (o)')&(win<>curwin) then
jj=find(windows(:,2)==win)
  if jj <> [] then
    btn=99  //mode copy
    if or(windows(jj,1)==100000) then
      btn=111  //mode open-set (cliquer dans navigator)
    end
  end
end





function [x,y,typ]=IFTHEL_f(job,arg1,arg2)
// Copyright INRIA
x=[];y=[];typ=[]
select job
case 'plot' then
  standard_draw(arg1)
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1.graphics;exprs=graphics.exprs
  model=arg1.model;
  if exprs==[] then exprs=string(1);end
  while %t do
    [ok,inh,exprs]=getvalue('Set parameters',..
	['Inherit (1: no, 0: yes)'],list('vec',1),exprs)
    if ~ok then break,end
    if inh==0 then inh=[]; else inh=1;end
    [model,graphics,ok]=check_io(model,graphics,1,[],inh,[1;1])
      if ok then
	graphics.exprs=exprs;
	model.evtin=inh;
	model.sim(2)=-1
	x.graphics=graphics;x.model=model
	break
      end
  end
case 'define' then
  model=scicos_model()
  model.sim=list('ifthel',-1)
  model.in=1
  model.evtin=1
  model.evtout=[1;1]
  model.blocktype='l'
  model.firing=[-1 -1]
  model.dep_ut=[%t %f]
  
  gr_i=['txt=[''If in>0'';'' '';'' then    else''];';
    'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'');']
  exprs=string(1);
  x=standard_define([3 3],model,exprs,gr_i)
end
endfunction

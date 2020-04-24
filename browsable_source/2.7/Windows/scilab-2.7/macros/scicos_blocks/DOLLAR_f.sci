function [x,y,typ]=DOLLAR_f(job,arg1,arg2)
// Copyright INRIA
x=[];y=[];typ=[];
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
  while %t do
    [ok,a,exprs]=getvalue('Set dollar block parameters',..
	'initial condition',list('vec',-1),exprs)
    if ~ok then break,end
    out=size(a,'*');if out==0 then out=[],end
    in=out
    if ok then
      graphics.exprs=exprs;
      model.dstate=a;model.in=in;model.out=out
      x.graphics=graphics;x.model=model
      break
    end
  end
case 'define' then
  z=0
  in=1
  exprs=string(z)
  model=scicos_model()
  model.sim='dollar'
  model.in=in
  model.out=in
  model.evtin=1
  model.dstate=z
  model.blocktype='d'
  model.dep_ut=[%f %f]

  gr_i='xstringb(orig(1),orig(2),''1/z'',sz(1),sz(2),''fill'')'
  x=standard_define([2 2],model,exprs,gr_i)
end
endfunction

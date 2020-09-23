function [x,y,typ]=scifunc_block(job,arg1,arg2)
//%Description
// job=='plot' :      block drawing
//                    arg1 is block data structure
//                    arg2 :unused
// job=='getinputs' : return position and type of inputs ports
//                    arg1 is block data structure
//                    x  : x coordinates of ports
//                    x  : y coordinates of ports
//                    typ: type of ports
// job=='getoutputs' : return position and type of outputs ports
//                    arg1 is block data structure
//                    x  : x coordinates of ports
//                    x  : y coordinates of ports
//                    typ: type of ports
// job=='getorigin'  : return block origin coordinates
//                    x  : x coordinates of block origin
//                    x  : y coordinates of block origin
// job=='set'        : block parameters acquisition
//                    arg1 is block data structure
//                    x is returned block data structure
// job=='define'     : corresponding block data structure initialisation
//                    arg1: name of block parameters acquisition macro
//                    x   : block data structure
//%Block data-structure definition
// bl=list('Block',graphics,model,init,'standard_block')
//  graphics=list([xo,yo],[l,h],orient,label)
//          xo          - x coordinate of block origin
//          yo          - y coordinate of block origin
//          l           - block width
//          h           - block height
//          orient      - boolean, specifies if block is tilded
//          label       - string block label
//  model=list(eqns,#input,#output,#clk_input,#clk_output,state,..
//             rpar,ipar,typ [,firing])
//          eqns        - function name (in string form if fortran routine)
//          #input      - vector of input port sizes
//          #output     - vector of ouput port sizes
//          #clk_input  - vector  of clock inputs port sizes
//          #clk_output - vector  of clock output port sizes
//          state       - vector (column) of initial condition
//          rpar        - vector (column) of real parameters
//          ipar        - vector (column) of integer parameters
//          typ         - string: 'c' if block is continuous, 'd' if discrete
//                        'z' if zero-crossing.
//          firing      - vector of initial ouput event firing times
//
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
  needcompile=0
  x=arg1
  model=arg1(3);graphics=arg1(2);
  label=graphics(4)
  while %t do
    [ok,i,o,ci,co,xx,z,type_,rpar,auto0,lab]=..
	getvalue('Set scifunc_block parameters',..
	  ['input ports sizes';
	  'output port sizes';
	  'input event ports sizes';
	  'output events ports sizes';
	  'initial continuous state';
	  'initial discrete state';
	  'System type (c,d,z or l)';
	  'System parameters vector';
	  'initial firing vector (<0 for no firing)'],..
	  list('vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,..
	  'str',1,'vec',-1,'vec','sum(x4)'),label(1))
    if ~ok then break,end
    label(1)=lab
    type_=stripblanks(type_)
    xx=xx(:);z=z(:);rpar=rpar(:)
    nrp=prod(size(rpar))
    // create simulator
    i=int(i(:));ni=size(i,1);
    o=int(o(:));no=size(o,1);
    ci=int(ci(:));nci=size(ci,1);
    co=int(co(:));nco=size(co,1);
    [ok,tt,dep_ut]=genfunc1(label(2),i,o,nci,nco,size(xx,1),size(z,1),..
	nrp,type_)
    if ~ok then break,end
    [model,graphics,ok]=check_io(model,graphics,i,o,ci,co)
    if ok then
      auto=auto0
      model(6)=xx
      model(7)=z
      model(8)=rpar
      if or(model(9)<>tt) then needcompile=4,end
      model(9)=tt
      model(10)=type_
      model(11)=auto
      model(12)=dep_ut
      x(3)=model
      label(2)=tt
      graphics(4)=label
      x(2)=graphics
      break
    end
  end
  needcompile=resume(needcompile)
case 'define' then
  in=1
  out=1
  clkin=[]
  clkout=[]
  x0=[]
  z0=[]
  typ='c'
  auto=[]
  rpar=[]
  model=list(list('scifunc',3),in,out,clkin,clkout,x0,z0,rpar,0,typ,auto,[%t %f],..
      ' ',list());
  label=list([sci2exp(in);sci2exp(out);sci2exp(clkin);sci2exp(clkout);
	strcat(sci2exp(x0));strcat(sci2exp(z0));typ;
	strcat(sci2exp(rpar));sci2exp(auto)],..
	    list('y=sin(u)',' ',' ','y=sin(u)',' ',' ',' '))
  gr_i=['xstringb(orig(1),orig(2),''Scifunc'',sz(1),sz(2),''fill'');']
  x=standard_define([2 2],model,label,gr_i)
end



function [stk,txt,top]=sci_fopen()
// Copyright INRIA
txt=[]
first=stk(top-rhs+1)
if first(5)=='1' then
  filename=first(1)
elseif first(5)=='10' then
  write(logfile,'fopen(fid) has no translation')
  txt='//!fopen(fid) has no translation'
  filename=first(1)
else
  write(logfile,'fopen(filename,...) assumed')
  txt='//!fopen(filename,...) assumed'
  filename=first(1)
end

if rhs==1 then
  permission='rb'
else
  permission=stk(top-rhs+2)(1)
end
if lhs==1 then
  if lst(ilst+1)(1)=='1' then 
    fid=lhsvarsnames(),
    err=gettempvar()
  else 
    fid=gettempvar(1),
    err=gettempvar(2)
  end
  txt=['['+fid+','+err+'] = mopen('+filename+','+permission+')';
      'if '+err+'<0 then '+fid+' = -1;end']
  stk=list(' ','-2','1','1','1')
else
  [fid,mess]=lhsvarsnames()
  err=gettempvar()
  txt=['['+fid+','+err+'] = mopen('+filename+','+permission+')';
      'if '+err+'<0 then '+..
	  fid+' = -1;'+mess+' = ''Cannot open file.'''+..
	  ';else '+mess+' = '''';end']
  stk=list(list(' ','-2','1','1','1'),..
      list(' ','-2','1','1','10'))
end


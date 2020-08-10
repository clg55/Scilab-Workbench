function wpar=do_window(wpar)
// Copyright INRIA
wd=wpar(1);w=wd(1);h=wd(2);
nm=wpar(2)(1)
//if wpar(3)==[] then //super block
  while %t do
    [ok,nm,h,w]=getvalue('Set parameters',[
	'Super block name';
	'Window height';
	'Window width'],list('str',1,'vec',1,'vec',1),[nm;string([h;w])])
    if ~ok then break,end
    if or([h,w]<=0) then
      message('Parameters must be positive')
    else
      drawtitle(wpar)
      wpar(1)(1)=w
      wpar(1)(2)=h
      wpar(2)(1)=nm
      drawtitle(wpar)
      break
    end
  end
//else
//  while %t do
//   [ok,h,w]=getvalue('Set parameters',[
//	'Window height';
//	'Window width'],list('vec',1,'vec',1),[string([h;w])])
//    if ~ok then break,end
//    if or([h,w]<=0) then
//      message('Parameters must  be positive')
//    else
//      wpar(1)(1)=w
//      wpar(1)(2)=h
//      break
//    end
//  end
//end



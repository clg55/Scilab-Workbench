function bad_connection(path_out,prt_out,nout,path_in,prt_in,nin)
// alert for badly connected blocks
// path_out : Path of the "from block" in scs_m
// path_in  : Path of the "to block" in scs_m
//!
// Copyright INRIA
[lhs,rhs]=argn(0)
if rhs==6 then  //two connected blocks
  lp=mini(size(path_out,'*'),size(path_in,'*'))
  k=find(path_out(1:lp)<>path_in(1:lp))
  path=path_out(1:k(1)-1) // common superbloc path
  path_out=path_out(k(1)) // "from" block number
  path_in=path_in(k(1))   // "to" block number
  
  if path==[] then
    hilite_obj(scs_m(path_out))
    if or(path_in<>path_out) then hilite_obj(scs_m(path_in)),end

    message(['Hilited block(s) have connected ports ';
	'with  incompatible sizes';
	' output port '+string(prt_out)+' size is :'+string(nout);
	' input port '+string(prt_in)+' size is  :'+string(nin)]); 
    hilite_obj(scs_m(path_out))
    if or(path_in<>path_out) then hilite_obj(scs_m(path_in)),end
  else
    mxwin=maxi(winsid())
    for k=1:size(path,'*')
      hilite_obj(scs_m(path(k)))
      scs_m=scs_m(path(k))(3)(8);
      scs_show(scs_m,mxwin+k)
    end
    hilite_obj(scs_m(path_out))
    if or(path_in<>path_out) then hilite_obj(scs_m(path_in)),end
    message(['Hilited block(s) have connected ports ';
	'with  incompatible sizes';
	string(prt_out)+' output port size is :'+string(nout);
	string(prt_in)+' input port size is  :'+string(nin)]); 
    for k=size(path,'*'):-1:1,xdel(mxwin+k),end
    scs_m=null()
    unhilite_obj(scs_m(path(1)))
  end
else // connected links do not verify block contraints
  if rhs==2 then 
    mess=prt_out;
  else
    mess=['Hilited block has connected ports ';
	'with  incompatible sizes']
  end
  path=path_out(1:$-1) // superbloc path
  path_out=path_out($) //  block number
  
  if path==[] then
    hilite_obj(scs_m(path_out))
    
    message(mess)
    hilite_obj(scs_m(path_out))
  else
    mxwin=maxi(winsid())
    for k=1:size(path,'*')
      hilite_obj(scs_m(path(k)))
      scs_m=scs_m(path(k))(3)(8);
      scs_show(scs_m,mxwin+k)
    end
    hilite_obj(scs_m(path_out))
    message(mess)
    for k=size(path,'*'):-1:1,xdel(mxwin+k),end
    scs_m=null()
    unhilite_obj(scs_m(path(1)))
  end
end



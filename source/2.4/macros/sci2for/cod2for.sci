function [txt,ilst,vnms,vtps,nwrk]=cod2for(lst,ilst,vnms,vtps,nwrk)
//
//!
// Copyright INRIA
nlst=size(lst)
txt=[]
ilst=ilst-1
while ilst<nlst then
  ilst=ilst+1
  op=lst(ilst)
  if type(op)==15 then return,end
 
  //write(6,'cod2for '+op(1)+' '+string(ilst))
  select op(1)
  case '1' then //stackp
    //write(6,'stackp '+op(2));
    prev=lst(ilst-1)
    if size(prev,'*')<2 then
      lhs=1
    elseif prev(1:2)==['5','25']|prev(1)=='20' then
      lhs=evstr(prev(4))
    else
      lhs=1
    end
    ilst=ilst-1
    for k=1:lhs
      expk=stk(k);typ=expk(2)
      it=prod(size(expk(1)))-1
      ilst=ilst+1
      opk=lst(ilst);
      if expk(3)<>'-1' then
        k3=find(opk(2)==vnms(:,2))
        if or(opk(2)==nwrk(10))|or(opk(2)==nwrk(12)) then
          nv=size(vtps)+1  
          vnms=[vnms;[expk(1),opk(2)]]
          vtps(nv)=list(expk(3),expk(4),expk(5),it)
        elseif k3==[] then
// la variable n'existe pas il faut lui allouer de la place
          if isnum(expk(4))&isnum(expk(5)) then
//         les dimensions sont des nombres on alloue localement
            out=opk(2)
//	    vnms=[vnms;[out,opk(2)]]
	    vnms=[vnms;[expk(1),out]]
	    nv=size(vtps)
	    vtps(nv+1)=list(expk(3),expk(4),expk(5),it)
          else
//          dimensions formelles on alloue dans les tableau de travail
            [out,nwrk,t1]=getlocal(nwrk,opk(2),expk(3),expk(4),expk(5))
            txt=[txt;t1]
	    vnms=[vnms;[out,opk(2)]]
	    nv=size(vtps)
	    vtps(nv+1)=list(expk(3),expk(4),expk(5),it)
	  end
        else
//  la variable existe deja on modifie eventuellement type et dim
          v=vtps(k3)
          if k3<=macrhs then
             if v(1)==expk(3)&v(2)==expk(4)&v(3)==expk(5) then
               out=opk(2)
	     else
               warning('input variable :'+vnms(k3,2)+..
                             ' changed type or dimensions')
               out=opk(2)	 
             end
          else
             if v(1)=='?'|v(1)==expk(3) then
               out=opk(2)
               vtps(k3)=list(expk(3),expk(4),expk(5),it)
             else
               txt=[txt;'C WARNING local variable  :'+vnms(k3,2)+..
                                                     ' changed its type!']
             end
          end
        end

        if typ<>'-1' then
          if expk(4)=='1'&expk(5)=='1' then
             txt=[txt;' '+out+' = '+expk(1)]
	   elseif expk(4)=='0'|expk(5)=='0' then
	   else
             select expk(3)
             case '0' then routine='icopy'
             case '1' then routine='dcopy'
             else error('cod2for:this type is not implemented'),
             end
             mn=mulf(expk(4),expk(5))
             txt=[txt;gencall([routine,mn,expk(1),'1',out,'1'])]
          end
        end
      end
    end
  case '12' then //pause
    txt=[txt;' pause']
  case '13' then //break
 
    txt=[txt;' break']
  case '14' then //abort
    txt=[txt;' abort']
  case '15' then ,//eol
    txt=[txt;'c']
//    write(6,'ligne')
  case '99' then //return
    txt=[txt;' return']
  else
    [stk,t1,ilst,vnms,vtps,nwrk]=exp2for(lst,ilst,vnms,vtps,nwrk);
    txt=[txt;t1]
    ilst=ilst-1
  end
end
ilst=ilst+1




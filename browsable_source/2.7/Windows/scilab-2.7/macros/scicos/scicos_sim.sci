function sim=scicos_sim(v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12,v13,v14,v15,v16,v17,v18,v19,v20,v21,v22,v23,v24,v25,v26,v27,v28,v29,v30)
  if exists('funs','local')==0 then funs=[],end
  if exists('xptr','local')==0 then xptr=[],end
  if exists('zptr','local')==0 then zptr=[],end
  if exists('izptr','local')==0 then izptr=[],end
  if exists('inpptr','local')==0 then inpptr=[],end
  if exists('outptr','local')==0 then outptr=[],end
  if exists('inplnk','local')==0 then inplnk=[],end
  if exists('outlnk','local')==0 then outlnk=[],end
  if exists('lnkptr','local')==0 then lnkptr=[],end
  if exists('rpar','local')==0 then rpar=[],end
  if exists('rpptr','local')==0 then rpptr=[],end
  if exists('ipar','local')==0 then ipar=[],end
  if exists('ipptr','local')==0 then ipptr=[],end
  if exists('clkptr','local')==0 then clkptr=[],end
  if exists('ordptr','local')==0 then ordptr=[],end
  if exists('execlk','local')==0 then execlk=[],end
  if exists('ordclk','local')==0 then ordclk=[],end
  if exists('cord','local')==0 then cord=[],end
  if exists('oord','local')==0 then oord=[],end
  if exists('zord','local')==0 then zord=[],end
  if exists('critev','local')==0 then critev=[],end
  if exists('nb','local')==0 then nb=[],end
  if exists('ztyp','local')==0 then ztyp=[],end
  if exists('nblk','local')==0 then nblk=[],end
  if exists('ndcblk','local')==0 then ndcblk=[],end
  if exists('subscr','local')==0 then subscr=[],end
  if exists('funtyp','local')==0 then funtyp=[],end
  if exists('iord','local')==0 then iord=[],end
  if exists('labels','local')==0 then labels=[],end
  sim=tlist(['scs','funs','xptr','zptr','izptr','inpptr',..
	     'outptr','inplnk','outlnk','lnkptr','rpar',..
	     'rpptr','ipar','ipptr','clkptr','ordptr',..
	     'execlk','ordclk','cord','oord','zord',..
	     'critev','nb','ztyp','nblk','ndcblk',..
	     'subscr','funtyp','iord','labels'],..
	    funs,xptr,zptr,izptr,inpptr,..
	    outptr,inplnk,outlnk,lnkptr,rpar,..
	    rpptr,ipar,ipptr,clkptr,ordptr,..
	    execlk,ordclk,cord,oord,zord,..
	    critev,nb,ztyp,nblk,ndcblk,..
	    subscr,funtyp,iord,labels)
  
endfunction

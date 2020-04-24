function [%pt,scs_m,needcompile]=getlink(%pt,scs_m,needcompile)
//edition of a link from an output block to an input  block
// Copyright INRIA
  dash=xget('dashes')

  //----------- get link origin --------------------------------------
  //------------------------------------------------------------------
  while %t
    if %pt==[] then
      [btn,xc1,yc1,win,Cmenu]=cosclick()
      if Cmenu<>[] then
	%pt=[]
	[Cmenu]=resume(Cmenu)
      elseif btn>31 then
	Cmenu=%tableau(min(100,btn-31));%pt=[xc1;yc1];
	if Cmenu==emptystr() then Cmenu=[];%pt=[];end
	[%win,Cmenu]=resume(win,Cmenu)
      end
    else
      xc1=%pt(1);yc1=%pt(2);win=%win;%pt=[]
    end
    [kfrom,wh]=getblocklink(scs_m,[xc1;yc1])

    if kfrom<>[] then o1=scs_m.objs(kfrom);break,end
  end
  scs_m_save=scs_m,nc_save=needcompile

  if typeof(o1)=='Link' then  // add a split block
    pt=[xc1;yc1]
    [xx,yy,ct,from,to]=(o1.xx,o1.yy,o1.ct,o1.from,o1.to);
    if (-wh==size(xx,'*')) then  
      wh=-(wh+1)    
      // avoid with clicking at the end-point of link
    end

    // get split type
    [xout,yout,typout]=getoutputs(scs_m.objs(from(1)))
    clr=ct(1)

    typo=ct(2)
    if typo==1 then typp='out',else typp='evtout', end
    szout=getportsiz(scs_m.objs(from(1)),from(2),typp)

  // get initial split position
  wh=wh(1)
  if wh>0 then
    d=projaff(xx(wh:wh+1),yy(wh:wh+1),pt)
  else // a corner
    wh=-wh
    d=[xx(wh);yy(wh)]
  end
  // Note : creation of the split block and modifications of links are
  //        done later, the sequel assumes that the split block is added
  //        at the end of scs_m
  ks=kfrom;
  kfrom=lstsize(scs_m.objs)+1;port_number=2;
  xo=d(1);yo=d(2)
  fromsplit=%t
  else //connection comes from a block
    graphics1=o1.graphics
    orig = graphics1.orig
    sz   = graphics1.sz
    io   = graphics1.flip
    op   = graphics1.pout
    cop  = graphics1.peout
    [xout,yout,typout]=getoutputs(o1)
    if xout==[] then
      message('This block has no output port'),
      xset('dashes',dash)
      return
    end
    [m,kp1]=mini((yc1-yout)^2+(xc1-xout)^2)
    k=kp1
    xo=xout(k);yo=yout(k);typo=typout(k)
    if typo==1 then
      port_number=k
      if op(port_number)<>0 then
	message('selected port is already connected'),
	xset('dashes',dash)
	return
      end
      typp='out'
    else
      port_number=k-prod(size(find(typout==1)))
      if cop(port_number)<>0 then
	message('selected port is already connected'),
	xset('dashes',dash)
	return
      end
      typp='evtout'
    end
    fromsplit=%f
    clr=default_color(typo)
    szout=getportsiz(o1,port_number,typp)
  end
  from=[kfrom,port_number,0]
  xl=xo
  yl=yo


  //----------- get link path ----------------------------------------
  //------------------------------------------------------------------
  xset('dashes',clr)
  dr=driver()
  if dr=='Rec' then driver('X11'),end
  while %t do //loop on link segments
    xe=xo;ye=yo
    xpoly([xo;xe],[yo;ye],'lines')
    rep(3)=-1
    while rep(3)==-1 do //get a new point
      rep=xgetmouse(0)
      
      if rep(3)==2 then 
	xpoly([xl;xe],[yl;ye],'lines')
	if pixmap then xset('wshow'),end
	xset('dashes',dash)
	driver(dr);
	return
      end
      
      //erase last link segment
      xpoly([xo;xe],[yo;ye],'lines')
      //plot new position of last link segment
      xe=rep(1);ye=rep(2)
      xpoly([xo;xe],[yo;ye],'lines')
      if pixmap then xset('wshow'),end
    end
    kto=getblock(scs_m,[xe;ye])
    if kto<>[] then //new point designs the "to block"
      o2=scs_m.objs(kto);
      graphics2=o2.graphics;
      orig  = graphics2.orig
      sz    = graphics2.sz
      ip    = graphics2.pin
      cip   = graphics2.pein
      [xin,yin,typin]=getinputs(o2)
      //check connection
      if xin==[] then
	message('This block has no input port'),
	xpoly([xl;xe],[yl;ye],'lines')
	if pixmap then xset('wshow'),end
	xset('dashes',dash)
	driver(dr);
	return
      end
      [m,kp2]=mini((ye-yin)^2+(xe-xin)^2)
      k=kp2
      xc2=xin(k);yc2=yin(k)
      if typo<>typin(k)
	message(['This input port is not compatible with the port at the'
	         'link''s origin';
		 strcat(string([typo,typin(k)]),',')]),
	xpoly([xl;xe],[yl;ye],'lines')
	if pixmap then xset('wshow'),end
	xset('dashes',dash)
	driver(dr);
	return
      end
      if typo==1 then
	port_number=k
	if ip(port_number)<>0 then
	  message('selected port is already connected'),
	  xpoly([xl;xe],[yl;ye],'lines')
	  if pixmap then xset('wshow'),end
	  xset('dashes',dash)
	  driver(dr);
	  return
	end
	szin=getportsiz(o2,port_number,'in')
	if szin<>szout & mini([szin szout])>0 then
	  message(['Warning';
		   'selected ports don''t have the same  size'])
	end
      else
	port_number=k-prod(size(find(typin==1)))
	if cip(port_number)<>0 then
	  message('selected port is already connected'),
	  xpoly([xl;xe],[yl;ye],'lines')
	  if pixmap then xset('wshow'),end
	  xset('dashes',dash)
	  driver(dr);
	  return
	end
	szin=getportsiz(o2,port_number,'evtin')
	if szin<>szout & mini([szin szout])>0 then
	  message(['Warning';
		   'selected ports don''t have the same  size'])
	end
      end
      xpoly([xo;xe],[yo;ye],'lines')
      xpoly([xo;xc2],[yo;yc2],'lines')
      if pixmap then xset('wshow'),end
      break;
    else //new point ends current line segment
      if xe<>xo|ye<>yo then //to avoid null length segments
	xc2=xe;yc2=ye
	xpoly([xo;xc2],[yo;yc2],'lines')
	if abs(xo-xc2)<abs(yo-yc2) then
	  xc2=xo
	else
	  yc2=yo
	end
	xpoly([xo;xc2],[yo;yc2],'lines')
	if pixmap then xset('wshow'),end
	xl=[xl;xc2]
	yl=[yl;yc2]
	xo=xc2
	yo=yc2
      end
    end
  end //loop on link segments
  
  //make last segment horizontal or vertical
  typ=typo
  to=[kto,port_number,1]
  nx=prod(size(xl))
  if nx==1 then //1 segment link

    if fromsplit&(xl<>xc2|yl<>yc2) then
      //try to move split point
      if xx(wh)==xx(wh+1) then //split is on a vertical link
	if (yy(wh)-yc2)*(yy(wh+1)-yc2)<0 then
	  //erase last segment
	  xpoly([xl;xc2],[yl;yc2],'lines')
	  yl=yc2,
	  //draw last segment
	  xpoly([xl;xc2],[yl;yc2],'lines')
	  if pixmap then xset('wshow'),end
	end
      elseif yy(wh)==yy(wh+1) then //split is on a horizontal link
	if (xx(wh)-xc2)*(xx(wh+1)-xc2)<0 then
	  //erase last segment
	  xpoly([xl;xc2],[yl;yc2],'lines')
	  xl=xc2,
	  //draw last segment
	  xpoly([xl;xc2],[yl;yc2],'lines')
	  if pixmap then xset('wshow'),end
	end
      end
      d=[xl,yl]
    end
    //form link datas
    xl=[xl;xc2];yl=[yl;yc2]
  else
    if xl(nx)==xl(nx-1) then 
      //previous segment is vertical 
      
      //erase last and previous segments
      xpoly([xl(nx-1);xl(nx);xo;xc2],[yl(nx-1);yl(nx);yo;yc2],'lines')
      //draw last 2 segments
      xpoly([xl(nx-1);xl(nx);xc2],[yl(nx-1);yc2;yc2],'lines')
      if pixmap then xset('wshow'),end
      //form link datas
      xl=[xl;xc2];yl=[yl(1:nx-1);yc2;yc2]
    elseif yl(nx)==yl(nx-1) then 
      //previous segment is horizontal 
      
      //erase last and previous segments
      xpoly([xl(nx-1);xl(nx);xo;xc2],[yl(nx-1);yl(nx);yo;yc2],'lines')
      //draw last 2 sgements
      xpoly([xl(nx-1);xc2;xc2],[yl(nx-1);yl(nx);yc2],'lines')
      if pixmap then xset('wshow'),end
      //form link datas
      xl=[xl(1:nx-1);xc2;xc2];yl=[yl;yc2]
    else //previous segment is oblique
	 //nothing particular is done
	 xl=[xl;xc2];yl=[yl;yc2]
    end
  end
  lk=scicos_link(xx=xl,yy=yl,ct=[clr,typ],from=from,to=to)
  drawobj(lk)
  driver(dr);
  //----------- update objects structure -----------------------------
  //------------------------------------------------------------------
  if fromsplit then //link comes from a split
    nx=lstsize(scs_m.objs)+1
    //split old link
    from1=o1.from
    to1=o1.to
    link1=o1;
    link1.xx   = [xx(1:wh);d(1)];
    link1.yy   = [yy(1:wh);d(2)];
    link1.to   = [nx,1,1]
    
    link2=o1;
    link2.xx   = [d(1);xx(wh+1:size(xx,1))];
    link2.yy   = [d(2);yy(wh+1:size(yy,1))];
    link2.from = [nx,1,0];


    // create split block
    if typo==1 then
      sp=SPLIT_f('define')
      sp.graphics.orig = d;
      sp.graphics.pin  = ks;
      sp.graphics.pout = [nx+1;nx+2];
      
      SPLIT_f('plot',sp)
    else
      sp=CLKSPLIT_f('define')
      sp.graphics.orig  = d;
      sp.graphics.pein  = ks;
      sp.graphics.peout = [nx+1;nx+2];
      CLKSPLIT_f('plot',sp)
    end

    scs_m.objs(ks)=link1;
    scs_m.objs(nx)=sp
    scs_m.objs(nx+1)=link2;
    scs_m.objs(from1(1))=mark_prt(scs_m.objs(from1(1)),from1(2),'out',typ,ks)
    scs_m.objs(to1(1))=mark_prt(scs_m.objs(to1(1)),to1(2),'in',typ,nx+1)
  end
  
  //add new link in objects structure
  nx=lstsize(scs_m.objs)+1
  scs_m.objs($+1)=lk
  //update connected blocks
  scs_m.objs(kfrom)=mark_prt(scs_m.objs(kfrom),from(2),'out',typ,nx)
  scs_m.objs(kto)=mark_prt(scs_m.objs(kto),to(2),'in',typ,nx)

  drawobj(lk)

  xset('dashes',dash)
  needcompile=4
  [scs_m_save,nc_save,enable_undo,edited]=resume(scs_m_save,nc_save,%t,%t)
endfunction

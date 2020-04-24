function window_set_size(a)
  [lhs,rhs]=argn(0)

  rect=dig_bound(scs_m);
  if rect<>[] then
    w=rect(3)-rect(1);
    h=rect(4)-rect(2);
    if rhs==0 then j=1.5;a=max(600/(j*w),400/(j*h),j); end
  else
    w=600;h=400;rect=[0,0,w,h];
    if rhs==0 then a=1.5; end
  end


  xbasc()

  xset("wresize",0);
  width=%zoom*w*a;height=%zoom*h*a
  xset('wdim',width,height);
  b=(1-1/a)/2;
  xsetech([b,b,1/a,1/a],rect)
  
  r=xget('wpdim');
  %XSHIFT=max((width-r(1))/2,0)
  %YSHIFT=max((height-r(2))/2,0)
  xset('viewport',%XSHIFT,%YSHIFT)
endfunction

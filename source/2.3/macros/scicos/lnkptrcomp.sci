function lnkptr=lnkptrcomp(bllst,inpptr,outptr,inplnk,outlnk)
lnkbsz=[];
for blkout=1:length(bllst)
  for portout=1:outptr(blkout+1)-outptr(blkout)
    lnkbsz(outlnk(outptr(blkout)+portout-1))=bllst(blkout)(3)(portout)
  end	
end
lnkptr=cumsum([1;lnkbsz])


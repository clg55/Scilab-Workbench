function find_links(filein,fileout)
[lhs,rhs]=argn(0)
if rhs<>2 then error(39), end
if MSDOS then sep='\',else sep='/',end
txt=mgetl(filein);
d=grep(txt,"<LINK>");
if d==[] then mputl(txt,fileout); return; end
for k=d
  tt=txt(k);
  l1=strindex(tt,"<LINK>")
  l2=strindex(tt,"</LINK>")
  nlink=size(l1,"*")
  for i=1:nlink
    name=part(tt,[l1(1)+6:l2(1)-1])
    path=get_absolute_file_path(filein)+sep+filein
    l=getlink(name,path)
    tt=part(tt,[1:l1(1)-1])+..
	"<A href="""+l+"""><VERB>"+name+"</VERB></A>"+..
	part(tt,[l2(1)+7:length(tt)])
    l1=strindex(tt,"<LINK>")
    l2=strindex(tt,"</LINK>")
  end
  txt(k)=tt
end
mputl(txt,fileout)
endfunction

function t=getlink(name,absolute_path)
global %helps
name=stripblanks(name)
if MSDOS then sep='\',else sep='/',end
man=[]
for k=1:size(%helps,1)
  whatis=mgetl(%helps(k,1)+sep+'whatis.html')
  f=grep(whatis,name)
  if f<>[] then
    for k1=f
      w=whatis(k1)
      i=strindex(w,">"); j=strindex(w,"</A>")
      lname=part(w,i(2)+1:j-1)
      iname=strindex(lname,name) // iname could be a vector
      for ii=iname
	ok=%F
	if ii==1 then ok=%T // beginning of lname
	elseif ii+length(name)==length(lname)+1 then ok=%T // end of lname
	elseif (part(lname,ii-1)==" " & part(lname,ii+length(name))== " ") then ok= %T // in lname*
	end
	if ok then
	  i=strindex(w,"HREF="""); j=strindex(w,""">")
	  man=%helps(k,1)+sep+part(w,[i+6:j-1])
	end
	if man<>[] then break; end
      end
      if man<>[] then break; end
    end
  end
  if man<>[] then break; end
end
if man==[] then
  write(%io(2),"Bad LINK "+name+""" in this man");
  return;
end
t=relative_path(man,absolute_path)
endfunction

function p=relative_path(path,relative)
if MSDOS then sep='\',else sep='/',end
cpath=str2code(path)
crelative=str2code(relative)
n=min(size(cpath,"*"),size(crelative,"*"))
ncommon=find((cpath(1:n)==crelative(1:n))==%F)
ncommon=ncommon(1)-1
strcommon=part(path,[1:ncommon])
k=strindex(strcommon,sep)
ncommon=k($)
ndir=size(strindex(part(relative,[ncommon+1:length(relative)]),sep),"*")
p=""
for i=1:ndir
p=p+".."+sep
end
p=p+part(path,[ncommon+1:length(path)])
endfunction

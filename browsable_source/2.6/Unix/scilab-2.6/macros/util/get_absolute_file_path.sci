function dir = get_absolute_file_path(name)
//-------------------------------
// returns loader full path
//dir ='./';
dir ="";
if ~MSDOS then	sep = '/'; else sep = '\' ;end
[units,typs,nams]=file();
clear units typs
for k=size(nams,'*'):-1:1
  l=strindex(nams(k),name);
  if l<>[] then
    dir= part(nams(k),1:l($)-1);
    break
  end
end
if ~MSDOS then
  if part(dir,1)<>'/' then if dir<>"" then dir=sep+dir;end; dir=getcwd()+dir,end
else 
  if part(dir,2)<>':' then if dir<>"" then dir=sep+dir;end; dir=getcwd()+dir,end
end

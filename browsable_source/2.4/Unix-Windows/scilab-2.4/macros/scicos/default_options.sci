function options=default_options()
// Copyright INRIA
options=scsoptlist()
col3d=[0.8 0.8 0.8]
if xget('use color')==1 then
  d=xget('colormap');  
  [mc,kk]=mini(abs(d-ones(size(d,1),1)*col3d)*[1;1;1])
  if mc>.0001 then
    #col3d=size(d,1)+1
  else
    #col3d=kk
  end
  options('3D')=list(%t,kk)
else
  options('3D')=list(%f,0)
  col3d=[]
end
options('Background')=[8 1] //white,black
options('Link')=[1,5] //black,red
options('ID')=list([5 0],[4 0])
options('Cmap')=col3d

function options=scsoptlist(varargin)
lt=['scsopt','3D','Background','Link','ID','Cmap']
options=tlist(lt,varargin(:))

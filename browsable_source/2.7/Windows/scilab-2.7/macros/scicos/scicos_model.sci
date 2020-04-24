function model=scicos_model(v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12,v13)
//initialisation de model mlist
  if exists('sim','local')==0 then sim='',end
  if exists('in','local')==0 then in=[],end
  if exists('out','local')==0 then out=[],end
  if exists('evtin','local')==0 then evtin=[],end
  if exists('evtout','local')==0 then evtout=[],end
  if exists('state','local')==0 then state=[],end
  if exists('dstate','local')==0 then dstate=[],end
  if exists('rpar','local')==0 then rpar=[],end
  if exists('ipar','local')==0 then ipar=[],end
  if exists('blocktype','local')==0 then blocktype='c',end
  if exists('firing','local')==0 then firing=[],end
  if exists('dep_ut','local')==0 then dep_ut=[%f %f],end
  if exists('label','local')==0 then label='',end
  
  model=mlist(['model','sim','in','out','evtin','evtout','state','dstate',..
	       'rpar','ipar','blocktype','firing','dep_ut','label'],..
	      sim,in,out,evtin,evtout,state,dstate,..
	      rpar,ipar,blocktype,firing,dep_ut,label)
endfunction

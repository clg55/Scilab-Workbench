function [cw]=show_graph(g,win_meta,wdim,wpdim)
// Copyright Inria/Enpc 
// win_meta = number or 'new' or 'rep'
// wdim like in xset 
// wpdim idem   
[lhs,rhs]=argn(0)
gmode='rep';
if rhs == 3 then wpdim=wdim;end;
if rhs == 2 then 
   wdim=[700,700];wpdim=[700,700];
end 
if rhs <= 1 then
   wdim=[700,700];wpdim=[700,700];
   win_meta = xget('window');
end 
if type(win_meta)==10 ; 
  if win_meta=='rep' then win_meta=xget('window');
  elseif win_meta=='new' then 
     wins= winsid();
     if wins==[] then win_meta = 0; else win_meta = maxi(wins)+1;end 
  else error('Argument '+win_meta+' is not recognized');
  end 
end 

// g
check_graph(g)
// making defaults
n=g('node_number')
ma=prod(size(g('tail')))
// node_name
if size(g('node_name'))==0 then
  g('node_name')=string(1:n)
end
// node_type
if size(g('node_type'))==0 then
  g('node_type')=0*(1:n)
end
// node_x
if size(g('node_x'))==0 then
  g('node_x')=0*(1:n)
end
// node_y
if size(g('node_y'))==0 then
  g('node_y')=0*(1:n)
end
// node_color
if size(g('node_color'))==0 then
  g('node_color')=0*(1:n)
end
// node_diam
if size(g('node_diam'))==0 then
  g('node_diam')=0*(1:n)
end
// node_border
if size(g('node_border'))==0 then
  g('node_border')=0*(1:n)
end
// node_font_size
if size(g('node_font_size'))==0 then
  g('node_font_size')=0*(1:n)
end
// node_demand
if size(g('node_demand'))==0 then
  g('node_demand')=0*(1:n)
end
// edge_name
if size(g('edge_name'))==0 then
  g('edge_name')=string(1:ma)
end
// edge_color
if size(g('edge_color'))==0 then
  g('edge_color')=0*(1:ma)
end
// edge_width
if size(g('edge_width'))==0 then
  g('edge_width')=0*(1:ma)
end
// edge_hi_width
if size(g('edge_hi_width'))==0 then
  g('edge_hi_width')=0*(1:ma)
end
// edge_font_size
if size(g('edge_font_size'))==0 then
  g('edge_font_size')=0*(1:ma)
end
// edge_length
if size(g('edge_length'))==0 then
  g('edge_length')=0*(1:ma)
end
// edge_cost
if size(g('edge_cost'))==0 then
  g('edge_cost')=0*(1:ma)
end
// edge_min_cap
if size(g('edge_min_cap'))==0 then
  g('edge_min_cap')=0*(1:ma)
end
// edge_max_cap
if size(g('edge_max_cap'))==0 then
  g('edge_max_cap')=0*(1:ma)
end
// edge_q_weight
if size(g('edge_q_weight'))==0 then
  g('edge_q_weight')=0*(1:ma)
end
// edge_q_orig
if size(g('edge_q_orig'))==0 then
  g('edge_q_orig')=0*(1:ma)
end
// edge_weight
if size(g('edge_weight'))==0 then
  g('edge_weight')=0*(1:ma)
end
// default_node_diam
if size(g('default_node_diam'))==0 then
  g('default_node_diam')=0
end
// default_node_border
if size(g('default_node_border'))==0 then
  g('default_node_border')=0
end
// default_edge_width
if size(g('default_edge_width'))==0 then
  g('default_edge_width')=0
end
// default_edge_hi_width
if size(g('default_edge_hi_width'))==0 then
  g('default_edge_hi_width')=0
end
// default_font_size
if size(g('default_font_size'))==0 then
  g('default_font_size')=0
end
// node_label
is_nlabel=1

if size(g('node_label'))==0 then
  g('node_label')=string(zeros(1,n))
  is_nlabel=0
end
// edge_label
is_elabel=1
if size(g('edge_label'))==0 then
  g('edge_label')=string(zeros(1,ma))
  is_elabel=0
end
// Is there a current metanet window?
//r=netwindows(); cw=r(2)
//if cw==0 then 
// cw=m6inimet(' ',winsize(1),winsize(2))
//end
scigraph(wdim=wdim,wpdim=wpdim,window=win_meta,gmode=gmode);
scale=1;
irep=0;
m6show_scig(g,g('name'),ma,win_meta,irep,scale,is_nlabel,is_elabel)
cw=win_meta;


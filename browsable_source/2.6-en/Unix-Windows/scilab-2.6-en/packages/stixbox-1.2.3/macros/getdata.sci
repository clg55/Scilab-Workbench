function [x]=getdata(i)
x=[];
[nargout,nargin] = argn(0)
 
if nargin<1 then
//  help('getdata');
//  i = input('Which dataset? > ');

dd=['1  Phosphorus Data'; 
'2  Scottish Hill Race Data'; 
'3  Salary Survey Data'; 
'4  Health Club Data'; 
'5  Brain and Body Weight Data'; 
'6  Cement Data'; 
'7  Colon Cancer Data'; 
'8  Growth Data'; 
'9  Consumption Function'; 
'10 Cost-of-Living Data'; 
'11 Demographic Data';
'12 Cable Data';
'13 Service call';
'14 Phone call';
'15 Turnover Data';
'16 Unemployment Data';
'17 Quality Control';
'18 Graphics cards ';
'19 Data Processing System development';
'20 Paper Data';
'21 Bulb Data';
'22 Memory Chip Data';
'23 French firm Data'];

i=x_choose(dd,'DATASETS Famous datasets');
end 

if i == 0 then return ;end 
 
if nargin<2 then
  s = ['datas'+string(i)];
end

fofo='info'+s;

//modif S Steer
DIR=string(stixboxlib);DIR=strsubst(DIR(1),'macros','data')
fofo=DIR+fofo
exec(fofo,-1);
s=[s+'()'];
x = evstr(s);

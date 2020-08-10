function[]=pub()
xbasc();xselect()
rect=[0,0,10,10];
xbasc();
isoview(0,11,0,11)
//plot2d([],[],[1],"010"," ",rect);

deff('[x,y]=circle(amp,vx,vy)',['nn=.1';..
's=0:nn:2*%pi;x=vx*ones(s)+amp*sin(s);y=vy*ones(s)+amp*cos(s)']);


deff('[x,y]=spokes(amp1,amp2,vx,vy,nn)',['x=[],y=[]';
'for s=0:nn:2*%pi;x=[x,[vx+amp1*sin(s);vx+amp2*sin(s)]]';..
'y=[y,[vy+amp1*cos(s);vy+amp2*cos(s)]];end']);


[c_xr,c_yr]=circle(1.5,2,2);
[c_xri,c_yri]=circle(1.4,2,2);
[c_xf,c_yf]=circle(1.5,7,2);
[c_xfi,c_yfi]=circle(1.4,7,2);

xset("use color",0)
xset("pattern",5)
xfpoly(c_xf,c_yf,1)
xpoly(c_xf,c_yf,'lines',1)

xfpoly(c_xr,c_yr,1)
xpoly(c_xr,c_yr,'lines',1)

xset("pattern",16)
xfpoly(c_xfi,c_yfi,1)
xset("pattern",0)
xpoly(c_xfi,c_yfi,'lines',1)

xset("pattern",16)
xfpoly(c_xri,c_yri,1)
xset("pattern",0)
xpoly(c_xri,c_yri,'lines',1)

xset("use color",1)
[c_xg1,c_yg1]=circle(.5,4.374034,1.5472313);
xpoly(c_xg1,c_yg1,'lines',1)

[c_xg2,c_yg2]=circle(.3,4.374034,1.5472313);
xpoly(c_xg2,c_yg2,'lines',1)

[c_xg3,c_yg3]=circle(.1,2,2);
xpoly(c_xg3,c_yg3,'lines',1)

[c_xg3,c_yg3]=circle(.15,2,2);
xpoly(c_xg3,c_yg3,'lines',1)

[c_xg3,c_yg3]=circle(.2,2,2);
xpoly(c_xg3,c_yg3,'lines',1)

[s_xr,s_yr]=spokes(.2,1.4,2,2,.2);
[s_xf,s_yf]=spokes(.1,1.4,7,2,.2);
xset("pattern",14)
xpoly(s_xr,s_yr,'lines',0)
xpoly(s_xf,s_yf,'lines',0)

xset("pattern",2)
cy1=[1.9218241042345
    1.4983713355049
    3.7133550488599
    2.1661237785016
    1.9869706840391
    2.1172638436482
    1.9706840390879
    4.7882736156352
    4.9022801302932
    4.9185667752443
    4.7882736156352
    4.6579804560261
    4.4951140065147
    4.3973941368078
    4.3322475570033
    4.2833876221498
    4.2508143322476
    4.2345276872964
    4.3159609120521
    4.3485342019544
    4.3973941368078
    4.4951140065147
    4.5765472312704
    4.6742671009772
    4.7719869706840]

cx1=[    2.0247295208655
    4.3585780525502
    6.2442040185471
    6.7851622874807
    6.9242658423493
    6.9397217928903
    7.0170015455951
    5.9969088098918
    5.9969088098918
    6.1205564142195
    6.8315301391036
    6.9242658423493
    6.9551777434312
    6.9397217928903
    6.8778979907264
    6.7697063369397
    6.6769706336940
    6.5224111282844
    6.5069551777434
    6.5996908809892
    6.7387944358578
    6.8315301391036
    6.8315301391036
    6.7697063369397
    6.2132921174652]
xpoly(cx1,cy1,'lines',0);


cx2=[4.3431221020093
    6.1978361669243
    6.0896445131376
    4.8377125193199
    3.3075734157651
    3.7248840803709
    3.8948995363215
    4.3894899536321]
cy2=[1.6775244299674
    3.8273615635179
    4.1530944625407
    4.1530944625407
    4.1530944625407
    3.2084690553746
    2.8664495114007
    1.7426710097720]
xpoly(cx2,cy2,'lines',0);
xpoly(cx1,cy1,'lines',0);



cx3=[6.0587326120556
    3.2921174652241
    3.0448222565688
    2.9520865533230
    3.2302936630603
    4.3585780525502
    2.1638330757342
    2.4574961360124
    2.4574961360124
    2.4420401854714
    2.4574961360124
    2.4729520865533]
cy3=[4.2671009771987
    4.2671009771987
    4.7882736156352
    4.7719869706840
    4.1205211726384
    1.5960912052117
    2.0195439739414
    2.5407166123779
    2.5081433224756
    2.5081433224756
    2.5081433224756
    2.5244299674267]
xpoly(cx3,cy3,'lines',0);

cx4=[3.2302936630603
    2.0710973724884
    2.0092735703246
    3.1993817619784
    3.1684698608964
    2.9984544049459
    2.8748068006182
    2.8129829984544
    2.7666151468315
    2.7202472952087
    2.6893353941267
    2.6738794435858
    2.6120556414219
    2.5656877897991
    2.5502318392581
    2.5347758887172
    2.5038639876352
    2.5347758887172
    2.4884080370943
    2.4420401854714
    2.4420401854714
    2.4574961360124
    2.4729520865533
    2.5656877897991
    2.5965996908810]

cy4=[4.0879478827362
    2.0358306188925
    2.0521172638436
    4.1856677524430
    4.2833876221498
    4.2345276872964
    4.1693811074919
    4.1042345276873
    4.0390879478827
    3.9250814332248
    3.8762214983713
    3.8273615635179
    3.7459283387622
    3.6482084690554
    3.6156351791531
    3.5667752442997
    3.5016286644951
    3.4364820846906
    3.4364820846906
    3.3713355048860
    3.3387622149837
    3.3061889250814
    3.3224755700326
    3.5342019543974
    3.5830618892508]
xpoly(cx4,cy4,'lines',0);

cx5=[6.0432766615147
    5.8887171561051
    5.9196290571870
    5.9969088098918
    5.9969088098918
    6.2287480680062
    6.2751159196291]
cy5=[4.2671009771987
    4.7719869706840
    4.8859934853420
    4.9185667752443
    4.8045602605863
    4.7719869706840
    4.8697068403909]
xpoly(cx5,cy5,'lines',0);

cx6=[2.6275115919629    
    2.6275115919629    
    2.6429675425039    
    2.6429675425039
    2.9675425038640    
    3.1375579598145    
    3.2921174652241    
    3.5239567233385
    3.6476043276662    
    3.7403400309119    
    3.7403400309119    
    3.6939721792890
    3.6321483771252    
    3.5703245749614    
    3.5394126738794    
    3.4312210200927
    3.1530139103555    
    2.9211746522411    
    2.8129829984544    
    2.7047913446677
    2.6120556414219    
    2.6120556414219    
    2.6275115919629]

cy6=[4.9674267100977    
    4.9348534201954    
    4.8534201954397    
    4.8208469055375
    4.7719869706840    
    4.7882736156352    
    4.8697068403909    
    4.8859934853420
    4.8371335504886    
    4.8859934853420    
    4.9348534201954    
    5.0162866449511
    5.0651465798046    
    5.0814332247557    
    5.0977198697068    
    5.0814332247557
    5.0814332247557    
    5.0814332247557    
    5.1140065146580    
    5.1465798045603
    5.0977198697068    
    5.0488599348534    
    4.9674267100977]

xset("pattern",13);
xfpoly(cx6,cy6,0);
xset("pattern",0)
xpoly(cx6,cy6,'lines',0);


cx7=[2.0247295208655
    1.9938176197836
    2.1638330757342
    2.0092735703246
    2.0247295208655
    2.0247295208655
    4.4204018547141]

cy7=[2.0521172638436
    1.9706840390879
    1.6286644951140
    1.4495114006515
    1.3843648208469
    1.2866449511401
    1.0423452768730]
xpoly(cx7,cy7,'lines',0);


cx8=[2.0092735703246
    4.3276661514683]

cy8=[2.1498371335505
    2.0521172638436]

xset("pattern",2);
//xfpoly(cx8,cy8,0);
xset("pattern",0)
xpoly(cx8,cy8,'lines',0);


cx9=[4.3894899536321
    4.8995363214838
    4.8840803709428
    4.9459041731066
    4.9768160741886
    5.0386398763524
    5.1004636785162
    3.7094281298300
    3.7403400309119
    3.7557959814529
    3.8330757341577
    4.2812982998454]
cy9=[1.4820846905537
    1.0423452768730
   0.89576547231270
   0.84690553745928
   0.97719869706840
   0.83061889250814
    1.0423452768730
    2.3289902280130
    2.1172638436482
    1.9381107491857
    2.0358306188925
    1.5960912052117]

xset("pattern",2);
//xfpoly(cx9,cy9,0);
xset("pattern",0)
xpoly(cx9,cy9,'lines',0);



cx10=[6.8778979907264
    7.0324574961360
    7.2642967542504
    7.2179289026275
    7.0633693972179
    6.9551777434312]

cy10=[4.7394136807818
    4.8697068403909
    4.6905537459283
    4.6254071661238
    4.7068403908795
    4.6254071661238]

xpoly(cx10,cy10,'lines',0);
xset("pattern",2);
xfpoly(cx10,cy10,0);
xset("pattern",0)

cx11=[7.0015455950541
    6.8624420401855
    6.7697063369397
    6.6615146831530
    6.5378670788253
    6.4605873261206
    6.3833075734158
    6.3678516228748
    6.3833075734158
    6.3678516228748
    6.3369397217929
    6.3060278207110
    6.2596599690881
    6.1514683153014
    6.1051004636785
    6.0587326120556
    5.9196290571870
    5.8114374034003]

cy11=[4.8371335504886
    5.5374592833876
    5.7491856677524
    5.7980456026059
    5.7980456026059
    5.7491856677524
    5.6351791530945
    5.4885993485342
    5.3094462540717
    5.2280130293160
    5.0162866449511
    4.9022801302932
    4.7394136807818
    4.5602605863192
    4.4951140065147
    4.4625407166124
    4.3648208469055
    4.2671009771987]

xpoly(cx11,cy11,'lines',0);

cx12=[7.0170015455951
    6.7387944358578
    6.5069551777434
    6.3523956723338
    6.1978361669243
    6.1360123647604
    6.1514683153014
    6.3060278207110
    6.4451313755796
    6.4605873261206
    6.6769706336940]

cy12=[4.8534201954397
    5.2280130293160
    5.5211726384365
    5.5374592833876
    5.5048859934853
    5.4071661237785
    5.2768729641694
    4.5765472312704
    4.0228013029316
    4.0228013029316
    3.4690553745928]

xpoly(cx12,cy12,'lines',0);


cx13=[6.6151468315301
    6.6924265842349
    6.7233384853168]

cy13=[3.4039087947883
    3.4527687296417
    3.3550488599349]

xpoly(cx13,cy13,'lines',0);



psi=[5.931198102016608E-002  0.657894736842105     ;
  6.049822064056940E-002  0.656250000000000     ;
  8.303677342823251E-002  0.641447368421053     ;
  0.102016607354686       0.621710526315789     ;
  0.118623962040332       0.597039473684211     ;
  0.129718640093787       0.579111842105263     ;
  0.137603795966785       0.550986842105263     ;
  0.138790035587189       0.523026315789474     ;
  0.137603795966785       0.488486842105263     ;
  0.135231316725979       0.452302631578947     ;
  0.133036773428233       0.419078947368421     ;
  0.132087781731910       0.384539473684211     ;
  0.135231316725979       0.337171052631579     ;
  0.141162514827995       0.299342105263158     ;
  0.154211150652432       0.241776315789474     ;
  0.173190984578885       0.194078947368421     ;
  0.195729537366548       0.167763157894737     ;
  0.217081850533808       0.151315789473684     ;
  0.238434163701068       0.143092105263158     ;
  0.237900355871886       8.174342105263155E-002;
  0.180308422301305       6.743421052631582E-002;
  0.177935943060498       3.125000000000000E-002;
  0.334697508896797       3.108552631578942E-002;
  0.333333333333333       6.578947368421062E-002;
  0.283511269276394       7.565789473684215E-002;
  0.283511269276394       0.136513157894737     ;
  0.307236061684460       0.146381578947368     ;
  0.329774614472123       0.161184210526316     ;
  0.349940688018980       0.190789473684211     ;
  0.360320284697509       0.223355263157895     ;
  0.368920521945433       0.263157894736842     ;
  0.373665480427046       0.300986842105263     ;
  0.374851720047450       0.338815789473684     ;
  0.373606168446026       0.373026315789474     ;
  0.371293001186240       0.414473684210526     ;
  0.370106761565836       0.449013157894737     ;
  0.371293001186240       0.478618421052632     ;
  0.374501758499414       0.498519736842105     ;
  0.379596678529063       0.504934210526316     ;
  0.393831553973903       0.523026315789474     ;
  0.421115065243179       0.555921052631579     ;
  0.404507710557533       0.557565789473684     ;
  0.380782918149466       0.559210526315789     ;
  0.360616844602610       0.544407894736842     ;
  0.351126927639383       0.532894736842105     ;
  0.346381969157770       0.516447368421053     ;
  0.343083235638922       0.487006578947369     ;
  0.342823250296560       0.445723684210526     ;
  0.342823250296560       0.409539473684211     ;
  0.342614302461899       0.368421052631579     ;
  0.341637010676157       0.320723684210526     ;
  0.340450771055753       0.292763157894737     ;
  0.335705812574140       0.251644736842105     ;
  0.327402135231317       0.223684210526316     ;
  0.316725978647687       0.195723684210526     ;
  0.301304863582444       0.172697368421053     ;
  0.282325029655991       0.162828947368421     ;
  0.281138790035587       0.626644736842105     ;
  0.333333333333333       0.625000000000000     ;
  0.334519572953737       0.641447368421053     ;
  0.192170818505338       0.689144736842105     ;
  0.190984578884935       0.672697368421053     ;
  0.245551601423488       0.638157894736842     ;
  0.238434163701068       0.169407894736842     ;
  0.217081850533808       0.180921052631579     ;
  0.191874258600237       0.226809210526316     ;
  0.180308422301305       0.269736842105263     ;
  0.173190984578885       0.322368421052632     ;
  0.171470937129300       0.366118421052632     ;
  0.172004744958482       0.412828947368421     ;
  0.175563463819692       0.467105263157895     ;
  0.176215895610913       0.506578947368421     ;
  0.174377224199288       0.554276315789474     ;
  0.170818505338078       0.569078947368421     ;
  0.157769869513642       0.597039473684211     ;
  0.139976275207592       0.615131578947368     ;
  0.126927639383155       0.626644736842105     ;
  0.115065243179122       0.638157894736842     ;
  0.103143534994069       0.644736842105263     ;
  6.138790035587190E-002  0.671217105263158     ;
  5.996441281138791E-002  0.658552631578948     ]
xset("pattern",10)
px=2.9;py=6.9;fac=5.2;
xfpoly(px*ones(81,1)+fac*psi(:,1),py*ones(81,1)+fac*psi(:,2),1)
xset("pattern",5)
px=3;py=7;fac=5;
xfpoly(px*ones(81,1)+fac*psi(:,1),py*ones(81,1)+fac*psi(:,2),1)
//xset("use color",0)
//xset("pattern",7)
//px=3;py=7;fac=5;
//xfpoly(px*ones(81,1)+fac*psi(:,1),py*ones(81,1)+fac*psi(:,2),1)
//xset("use color",1)
//xset("pattern",5)

psi2=[3.2457496136012    6.8729641693811;
    3.2921174652241    6.9218241042345;
    3.3384853168470    6.9218241042345;
    3.4312210200927    6.9543973941368;
    3.5085007727975    6.9869706840391;
    3.6012364760433    7.0195439739414;
    3.6785162287481    7.0521172638436;
    3.7712519319938    7.1172638436482;
    3.8176197836167    7.1172638436482;
    3.8176197836167    3.8762214983713;
    3.8485316846986    3.8273615635179;
    3.8794435857805    3.8110749185668;
    3.9567233384853    3.7459283387622;
    4.0340030911901    3.7296416938111;
    4.0803709428130    3.7296416938111;
    4.1267387944359    3.6970684039088;
    4.1731066460587    3.6482084690554;
    4.1731066460587    3.5993485342020;
    3.2612055641422    3.5993485342020;
    3.2302936630603    3.6644951140065;
    3.2302936630603    3.7133550488599;
    3.2921174652241    3.7296416938111;
    3.3693972179289    3.7459283387622;
    3.4312210200927    3.7785016286645;
    3.5085007727975    3.8110749185668;
    3.5548686244204    3.8436482084691;
    3.5857805255023    3.8925081433225;
    3.5703245749614    3.9739413680782;
    3.5548686244204    6.6775244299674;
    3.5548686244204    6.6938110749186;
    3.4930448222566    6.7426710097720;
    3.4621329211747    6.7752442996743;
    3.4157650695518    6.8078175895765;
    3.4003091190108    6.8241042345277;
    3.2921174652241    6.9055374592834]

px=6.5;py=8;fac=.6;
xfpoly((px-3)*ones(35,1)+fac*psi2(:,1),..
      (py-3)*ones(35,1)+fac*psi2(:,2),1)

psi3=[5.2173913043478    3.2078853046595;
    5.1472650771389    3.1362007168459;
    5.0911640953717    3.1003584229391;
    4.6423562412342    2.8494623655914;
    4.5441795231417    2.7598566308244;
    4.4460028050491    2.7060931899642;
    4.4039270687237    2.6344086021505;
    4.3197755960729    2.5448028673835;
    4.2917251051893    2.4551971326165;
    4.2356241234222    2.3297491039427;
    4.2075736325386    2.2043010752688;
    4.2215988779804    2.0788530465950;
    4.2776998597475    1.9892473118280;
    4.3478260869565    1.8458781362007;
    4.4319775596073    1.7383512544803;
    4.5161290322581    1.7204301075269;
    4.6423562412342    1.7741935483871;
    4.7685834502104    1.8100358422939;
    4.8527349228612    1.8817204301075;
    4.9789621318373    1.9534050179211;
    5.0631136044881    2.0071684587814;
    5.1472650771389    2.0609318996416;
    5.2314165497896    2.1505376344086;
    5.2734922861150    2.1684587813620;
    5.3155680224404    2.0609318996416;
    5.3716690042076    1.9892473118280;
    5.4417952314166    1.8817204301075;
    5.5259467040673    1.7741935483871;
    5.5680224403927    1.7562724014337;
    5.6942496493689    1.8100358422939;
    5.7784011220196    1.8637992831541;
    5.8765778401122    1.9534050179211;
    5.9467040673212    2.0788530465950;
    5.9186535764376    2.1505376344086;
    5.8625525946704    2.1146953405018;
    5.7924263674614    2.0609318996416;
    5.7363253856942    2.0609318996416;
    5.6521739130435    2.0609318996416;
    5.5960729312763    2.1146953405018;
    5.5960729312763    2.2401433691756;
    5.5820476858345    3.9605734767025;
    5.5680224403927    4.0681003584229;
    5.4698457223001    4.1397849462366;
    5.3997194950912    4.2293906810036;
    5.3155680224404    4.3010752688172;
    5.2173913043478    4.3189964157706;
    5.0771388499299    4.3010752688172;
    4.9649368863955    4.3010752688172;
    4.8667601683029    4.2831541218638;
    4.7545582047686    4.2473118279570;
    4.6143057503506    4.1756272401434;
    4.5021037868163    4.0681003584229;
    4.4179523141655    3.9784946236559;
    4.3478260869565    3.9068100358423;
    4.3057503506311    3.8530465949821;
    4.2496493688640    3.7455197132616;
    4.2075736325386    3.6738351254480;
    4.1935483870968    3.5842293906810;
    4.1795231416550    3.4587813620072;
    4.2356241234222    3.4050179211470;
    4.3197755960729    3.4229390681004;
    4.4039270687237    3.4587813620072;
    4.4740532959327    3.4946236559140;
    4.5161290322581    3.6021505376344;
    4.5722300140252    3.7455197132616;
    4.6143057503506    3.8888888888889;
    4.6704067321178    3.9964157706093;
    4.7405329593268    4.0860215053763;
    4.7966339410940    4.1397849462366;
    4.8807854137447    4.1756272401434;
    5.0210378681627    4.1935483870968;
    5.1192145862553    4.1935483870968;
    5.1612903225806    4.1577060931900;
    5.2033660589060    4.1218637992832;
    5.2594670406732    4.0681003584229;
    5.2875175315568    4.0143369175627;
    5.3015427769986    3.9605734767025;
    5.3155680224404    3.8888888888889;
    5.2875175315568    2.3835125448029;
    5.2734922861150    2.3476702508961;
    5.2173913043478    2.2580645161290;
    4.9509116409537    2.0609318996416;
    4.9228611500701    2.0430107526882;
    4.8527349228612    2.0250896057348;
    4.7685834502104    2.0071684587814;
    4.7265077138850    2.0430107526882;
    4.6844319775596    2.0609318996416;
    4.6283309957924    2.0967741935484;
    4.5722300140252    2.1326164874552;
    4.5301542776999    2.1684587813620;
    4.5301542776999    2.2759856630824;
    4.5301542776999    2.4910394265233;
    4.5722300140252    2.5448028673835;
    4.6704067321178    2.6344086021505;
    4.7545582047686    2.7240143369176;
    4.8106591865358    2.7956989247312;
    4.9088359046283    2.8673835125448;
    4.9929873772791    2.9211469534050;
    5.1051893408135    2.9569892473118;
    5.1753155680224    3.0107526881720;
    5.2454417952314    3.0286738351254]

px=7.75;py=7.8;fac=.6;
xfpoly((px-4)*ones(101,1)+fac*psi3(:,1),..
      (py-1.7)*ones(101,1)+fac*psi3(:,2),1)


psi4=[5.0951086956522    5.7833333333333;
    5.1630434782609    5.8500000000000;
    5.2445652173913    5.9000000000000;
    5.3260869565217    5.9166666666667;
    5.4076086956522    5.9500000000000;
    5.4755434782609    5.9500000000000;
    5.5706521739130    5.9333333333333;
    5.6793478260870    5.9166666666667;
    5.7744565217391    5.9000000000000;
    5.8967391304348    5.8166666666667;
    5.9782608695652    5.7666666666667;
    6.1005434782609    5.6500000000000;
    6.1684782608696    5.5500000000000;
    6.2228260869565    5.4333333333333;
    6.2364130434783    5.3000000000000;
    6.2500000000000    5.1833333333333;
    6.2635869565217    5.0000000000000;
    6.2771739130435    4.8666666666667;
    6.2635869565217    4.6500000000000;
    6.2092391304348    4.4333333333333;
    6.1956521739130    4.3000000000000;
    6.1548913043478    4.1666666666667;
    6.1005434782609    4.0833333333333;
    5.9918478260870    3.9666666666667;
    5.9103260869565    3.9000000000000;
    5.8152173913043    3.8666666666667;
    5.7472826086957    3.8333333333333;
    5.6385869565217    3.8166666666667;
    5.5298913043478    3.8166666666667;
    5.4347826086957    3.8166666666667;
    5.2989130434783    3.8500000000000;
    5.1766304347826    3.9000000000000;
    5.0679347826087    3.9666666666667;
    5.0271739130435    4.0666666666667;
    5.0135869565217    4.1833333333333;
    5.0407608695652    7.3833333333333;
    5.0135869565217    7.4000000000000;
    4.9864130434783    7.3833333333333;
    4.9592391304348    7.3500000000000;
    4.8505434782609    7.2833333333333;
    4.7961956521739    7.2666666666667;
    4.6603260869565    7.2500000000000;
    4.5923913043478    7.2166666666667;
    4.5244565217391    7.1666666666667;
    4.5108695652174    7.0833333333333;
    4.5516304347826    7.0333333333333;
    4.6603260869565    7.0166666666667;
    4.7146739130435    7.0000000000000;
    4.7826086956522    6.9666666666667;
    4.8097826086957    6.9000000000000;
    4.8097826086957    6.7833333333333;
    4.8369565217391    6.5833333333333;
    4.8097826086957    4.1000000000000;
    4.7690217391304    4.0000000000000;
    4.7554347826087    3.9166666666667;
    4.7418478260870    3.8666666666667;
    4.7282608695652    3.8166666666667;
    4.7010869565217    3.7333333333333;
    4.7282608695652    3.6833333333333;
    4.7826086956522    3.6833333333333;
    4.8233695652174    3.7166666666667;
    4.8505434782609    3.8166666666667;
    4.8777173913043    3.9000000000000;
    4.9048913043478    3.9000000000000;
    4.9728260869565    3.8833333333333;
    5.0000000000000    3.8500000000000;
    5.0407608695652    3.8000000000000;
    5.0815217391304    3.7833333333333;
    5.1358695652174    3.7333333333333;
    5.1766304347826    3.7000000000000;
    5.2717391304348    3.6666666666667;
    5.4076086956522    3.6500000000000;
    5.5163043478261    3.6833333333333;
    5.5706521739130    3.6833333333333;
    5.6657608695652    3.6833333333333;
    5.7744565217391    3.7166666666667;
    5.8967391304348    3.7666666666667;
    5.9918478260870    3.8333333333333;
    6.0461956521739    3.8666666666667;
    6.1548913043478    3.9333333333333;
    6.2771739130435    4.0333333333333;
    6.3586956521739    4.1166666666667;
    6.3994565217391    4.2166666666667;
    6.4538043478261    4.2833333333333;
    6.4673913043478    4.2833333333333;
    6.5217391304348    4.4666666666667;
    6.5625000000000    4.5500000000000;
    6.5625000000000    4.6000000000000;
    6.6032608695652    4.7166666666667;
    6.6168478260870    4.9166666666667;
    6.6032608695652    5.0833333333333;
    6.5625000000000    5.2833333333333;
    6.5081521739130    5.4833333333333;
    6.4538043478261    5.6500000000000;
    6.3858695652174    5.7833333333333;
    6.3043478260870    5.9166666666667;
    6.1956521739130    6.0333333333333;
    6.0597826086957    6.1333333333333;
    5.9239130434783    6.2000000000000;
    5.8152173913043    6.2333333333333;
    5.7065217391304    6.2500000000000;
    5.6114130434783    6.2333333333333;
    5.5298913043478    6.2166666666667;
    5.4076086956522    6.1666666666667;
    5.3396739130435    6.1500000000000;
    5.2445652173913    6.1166666666667;
    5.1902173913043    6.0833333333333;
    5.1358695652174    6.0666666666667;
    5.0815217391304    6.0333333333333]

px=9.3;py=8.7;fac=.57;
xfpoly((px-4.5)*ones(101,1)+fac*psi4(1:101,1),..
      (py-3.6)*ones(101,1)+fac*psi4(1:101,2),1)
xset('font',4,20)
xset("pattern",10)
z=-2;
xstring(z-.5,8.75,'F  r  e  e  !');
xset('font',3,20)
xset("pattern",2)
//xstring(z-1,8,'Scilab, a scientific');
//xstring(z-1,7.25,'software package');
xstring(z-.3,6.5,'from INRIA');
xset("pattern",0)
xset('font',3,2)
//xstring(0.5,0.15,'Bike Simulation (see $SCI/demos/bike_demo/bike_demo.sci)');

colored=%f;
colored=%f;
xset('default');
xset('font',2,1);
//[x,y,ok]=mod_curv([],[],'axy',list(' ',' ',' '),rect);

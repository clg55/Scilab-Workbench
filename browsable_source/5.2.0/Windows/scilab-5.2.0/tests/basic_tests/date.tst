//===================================================
// Author : Pierre MARECHAL
// Scilab team
// Copyright INRIA 
// Date : 28 Dec 2005
//===================================================

// test for datenum function
//===========================

if datenum(0,1,1) <> 1 then pause,end

if datenum(1973,8,4) <> 720840 then pause,end
if datenum(1970,1,1) <> 719529 then pause,end

if abs((datenum(2005,12,28,11,49,54) - 732674.49298611108)/ datenum(2005,12,28,11,49,54)) > %eps then pause,end

now_date = getdate();

one_sec = datenum(now_date(1),now_date(2),now_date(6),now_date(7),now_date(8),30) -  datenum(now_date(1),now_date(2),now_date(6),now_date(7),now_date(8),29);
one_sec_ref = 1/(3600*24);
if  abs( (one_sec - one_sec_ref) / one_sec ) > 1e-5 then pause,end

one_min = datenum(now_date(1),now_date(2),now_date(6),now_date(7),18,now_date(9)) -  datenum(now_date(1),now_date(2),now_date(6),now_date(7),17,now_date(9));
one_min_ref = 1/(60*24);
if  abs( (one_min - one_min_ref) / one_min ) > 1e-6 then pause,end

one_hour = datenum(now_date(1),now_date(2),now_date(6),18,now_date(8),now_date(9)) -  datenum(now_date(1),now_date(2),now_date(6),17,now_date(8),now_date(9));
one_hour_ref = 1/24;
if  abs( (one_hour - one_hour_ref) / one_hour ) > 1e-8 then pause,end

if floor(datenum(2005,12,28)) <> datenum(2005,12,28) then pause,end

// test for datevec function
//===========================

if datevec(1) <> [0,1,1,0,0,0] then pause,end
if datevec(719529) <> [1970,1,1,0,0,0] then pause,end

// test for getdate function
//===========================

dt = getdate(0);
if dt(1) <> 1970 then pause,end
if dt(2) <> 1 then pause,end
if dt(3) <> 1 then pause,end
if dt(4) <> 1 then pause,end
if dt(5) <> 5 then pause,end
if dt(6) <> 1 then pause,end
if dt(7) <> 1 then pause,end
if dt(8) <> 0 then pause,end
if dt(9) <> 0 then pause,end
if dt(10) <> 0 then pause,end

dt = getdate(1);
if dt(1) <> 1970 then pause,end
if dt(2) <> 1 then pause,end
if dt(3) <> 1 then pause,end
if dt(4) <> 1 then pause,end
if dt(5) <> 5 then pause,end
if dt(6) <> 1 then pause,end
if dt(7) <> 1 then pause,end
if dt(8) <> 0 then pause,end
if dt(9) <> 1 then pause,end
if dt(10) <> 0 then pause,end

dt = getdate(90542256);
if dt(1) <> 1972 then pause,end
if dt(2) <> 11 then pause,end
if dt(4) <> 318 then pause,end
if dt(5) <> 2 then pause,end
if dt(6) <> 13 then pause,end
if dt(7) <> 23 then pause,end
if dt(8) <> 37 then pause,end
if dt(9) <> 36 then pause,end

t1_ref = getdate("s");
t2_ref = datenum();
t3_ref = getdate();

t1 = t1_ref;
t2 = (t2_ref - datenum(1970,1,1,1,0,0)) *3600*24;
t3 = (datenum(t3_ref(1),t3_ref(2),t3_ref(6),t3_ref(7),t3_ref(8),t3_ref(9)) - datenum(1970,1,1,1,0,0)) * 3600 * 24;

if ((abs(t2-t1) > 1) & (abs(t2-t1)-3600 > 1))  then pause,end
if ((abs(t3-t1) > 1) & (abs(t3-t1)-3600 > 1))  then pause,end
if ((abs(t3-t2) > 1) & (abs(t3-t2)-3600 > 1))  then pause,end

// test for calendar function
//===========================

cal = calendar(2005,12);
title_ref = "Dec 2005";
week_ref = "   M      Tu     W      Th     F     Sat     Sun";
cal_ref = [0,0,0,1,2,3,4;5,6,7,8,9,10,11;12,13,14,15,16,17,18;19,20,21,22,23,24,25;26,27,28,29,30,31,0;0,0,0,0,0,0,0];

if cal(1) <> title_ref  then pause,end
if cal(2) <> week_ref  then pause,end
if or(cal(3) <> cal_ref)  then pause,end

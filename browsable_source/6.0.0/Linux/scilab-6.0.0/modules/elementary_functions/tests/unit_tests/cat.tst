// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2016 - Scilab Enterprises - Pierre-Aimé AGNEL
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// Unit tests for cat.sci function
// first example : concatenation according to the rows
dims=1; A1=[1 2 3]; A2=[4 5 6 ; 7 8 9]; A3=[10 11 12];
y=cat(dims, A1, A2, A3);
res = [1 2 3; 4 5 6; 7 8 9; 10 11 12];
assert_checkequal(y, res);,

// second example :  concatenation according to the columns
dims=2; A1=[1 2 3]'; A2=[4 5;7 8;9 10];
y=cat(dims, A1, A2)
res = [1 4 5; 2 7 8; 3 9 10];
assert_checkequal(y, res);,

// third example : concatenation according to the 3th dimension
dims=3; A1=matrix(1:12,[2,2,3]); A2=[13 15;14 16]; A3=matrix(17:32,[2,2,4]);
y=cat(dims, A1, A2, A3);
res = matrix( [1:32], [2, 2, 8] );

assert_checkequal(y, res);

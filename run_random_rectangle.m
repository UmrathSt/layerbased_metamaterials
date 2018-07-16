addpath('libraries');
addpath('../python_scripts');
clear;
UCDim = 10;
fr4_thickness = 2;
filling = 0.25;
eps_subs = 4.6;
tand = 0.02;
complemential = 0;

random_fss(UCDim, fr4_thickness, filling, eps_subs, tand, complemential);

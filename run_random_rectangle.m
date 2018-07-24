addpath('libraries');
addpath('../python_scripts');
clear;
UCDim = 20;
fr4_thickness = 2;
filling = 0.5;
eps_subs = 4.6;
tand = 0.02;
complemential = 0;

for filling = linspace(0.1, 0.9,9);
    random_fss(UCDim, fr4_thickness, filling, eps_subs, tand, complemential);
end;

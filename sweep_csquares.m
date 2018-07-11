clear;
clc;
physical_constants;
addpath('./libraries');

rect_gap = 0;

UCDim = 15;
L1 = 10;
L2 = 8;
complemential = 0;
fr4_thickness = 2;
eps_FR4 = 4.1;
number = 10;
fr4_thickness = 2;
Rsq = 15;
for Rsq = [10,50,100,150,250,300];
    csquares(UCDim, fr4_thickness, L1, L2, eps_FR4, Rsq, complemential);
end;

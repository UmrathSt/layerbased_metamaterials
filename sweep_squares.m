clear;
clc;
physical_constants;
addpath('./libraries');

rect_gap = 0;

UCDim = 15;
L1 = 8;
L2 = 2;
complemential = 0;
fr4_thickness = 2;
eps_FR4 = 4.1;
number = 10;
fr4_thickness = 2;
Rsq = 15;
for Rsq = [1000];
    squares(UCDim, fr4_thickness, L1, L2, eps_FR4, Rsq, complemential);
end;

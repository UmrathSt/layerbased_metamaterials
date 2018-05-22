clear;
clc;
physical_constants;
addpath('./libraries');

rect_gap = 0;

UCDim = 30;
L1 = 25;
L2 = 0;
complemential = 0;
fr4_thickness = 3.22;
eps_FR4 = 4.1;
number = 10;
fr4_thickness = 2;
Rsq = 15;
for Rsq = [0.1, 1, 10];
    squares(UCDim, fr4_thickness, L1, L2, eps_FR4, Rsq, complemential);
end;

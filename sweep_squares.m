clear;
clc;
physical_constants;
addpath('./libraries');

rect_gap = 0;

UCDim = 20;
L1 = 16;
L2 = 0;
complemential = 0;
fr4_thickness = 0.5
eps_FR4 = 4.6;

Rsq = 15;
for Rsq = [250, 300, 350, 400, 450];
    squares(UCDim, fr4_thickness, L1, L2, eps_FR4, Rsq, complemential);
end;

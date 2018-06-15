clear;
clc;
physical_constants;
addpath('./libraries');

rect_gap = 0;

UCDim = 20;
L1 = 10;
L2 = 6;
complemential = 0;
fr4_thickness = 1
rubber_thickness = 0.2;
eps_FR4 = 4.6;

Rsq = 15;
for Rsq = [150,200,250, 300, 350, 400, 450];
    squares(UCDim, fr4_thickness, rubber_thickness,L1, L2, eps_FR4, Rsq, complemential);
end;
